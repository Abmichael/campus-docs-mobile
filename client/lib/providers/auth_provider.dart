import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../config/api_config.dart';
import 'dart:convert';

class AuthState {
  final User? user;
  final String? error;
  final bool isLoading;
  final bool hasSeenOnboarding;

  const AuthState({
    this.user, 
    this.error, 
    this.isLoading = false,
    this.hasSeenOnboarding = false,
  });

  AuthState copyWith({
    User? user, 
    String? error, 
    bool? isLoading,
    bool? hasSeenOnboarding,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences before using');
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(apiClientProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio();
  // TODO: Add interceptors for JWT
  return ApiClient(dio);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  static const _userKey = 'cached_user';
  static const _onboardingKey = 'has_seen_onboarding';

  AuthNotifier(this._apiClient, this._prefs) : super(const AuthState()) {
    _initializeFromCache();
  }
  Future<void> _initializeFromCache() async {
    final userJson = _prefs.getString(_userKey);
    final token = await ApiConfig.token;
    final hasSeenOnboarding = _prefs.getBool(_onboardingKey) ?? false;

    if (userJson != null && token != null) {
      try {
        final user = User.fromJson(json.decode(userJson));
        state = state.copyWith(
          user: user.copyWith(token: token),
          isLoading: false,
          hasSeenOnboarding: hasSeenOnboarding,
        );
      } catch (e) {
        // If there's an error parsing cached data, clear it
        await _clearCache();
      }
    } else {
      state = state.copyWith(hasSeenOnboarding: hasSeenOnboarding);
    }
  }

  Future<void> _saveToCache(User user, String token) async {
    await _prefs.setString(_userKey, json.encode(user.toJson()));
    await ApiConfig.setToken(token);
  }
  Future<void> _clearCache() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_onboardingKey);
    await ApiConfig.clearToken();
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _apiClient.login({
        'email': email,
        'password': password,
      });

      print('Debug - Login response token: ${response.token}');

      final user = response.user.copyWith(token: response.token);
      await _saveToCache(user, response.token);

      final storedToken = await ApiConfig.token;
      print('Debug - Stored token after login: $storedToken');

      state = state.copyWith(user: user, isLoading: false, error: null);
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.error?.toString() ?? 'An error occurred during login',
      );
    } catch (e) {
      print('Error during login: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _clearCache();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }
  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> markOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
    state = state.copyWith(hasSeenOnboarding: true);
  }
}
