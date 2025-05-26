import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_provider.dart';

/// Theme mode provider that manages dark/light theme switching
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(ref.watch(sharedPreferencesProvider));
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeNotifier(this._prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final String? savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'dark':
          state = ThemeMode.dark;
          break;
        case 'light':
          state = ThemeMode.light;
          break;
        case 'system':
          state = ThemeMode.system;
          break;
        default:
          state = ThemeMode.light;
      }
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    state = themeMode;
    await _prefs.setString(_themeKey, themeMode.toString().split('.').last);
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newTheme);
  }
}
