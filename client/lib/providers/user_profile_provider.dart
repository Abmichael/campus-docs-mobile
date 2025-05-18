import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

// Provider that gets the current user from the auth state
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

// Provider that formats the user greeting
final userGreetingProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return 'Welcome!';
  }
  
  // Return greeting with user's name
  return 'Welcome, ${user.name}!';
});
