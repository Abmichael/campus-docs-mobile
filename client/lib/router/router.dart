import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/staff/dashboard_screen.dart';
import '../screens/staff/letter_templates_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/user_management_screen.dart';
import '../screens/student/request_form_screen.dart';
import '../screens/student/request_history_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/onboarding';

      // If not logged in and trying to access a protected route, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // If logged in and trying to access auth routes, redirect to appropriate dashboard
      if (isLoggedIn && (isAuthRoute || state.matchedLocation == '/')) {
        final user = authState.user!;
        switch (user.role) {
          case UserRole.student:
            return '/request-form';
          case UserRole.staff:
            return '/dashboard';
          case UserRole.administrator:
            return '/admin';
        }
      }

      // Check role-based access for protected routes
      if (isLoggedIn) {
        final user = authState.user!;
        final location = state.matchedLocation;

        // Admin-only routes
        if (location.startsWith('/admin') || location == '/users') {
          if (user.role != UserRole.administrator) {
            return '/request-form';
          }
        }

        // Staff-only routes
        if (location == '/dashboard' || location == '/letter-templates') {
          if (user.role != UserRole.staff &&
              user.role != UserRole.administrator) {
            return '/request-form';
          }
        }

        // Student-only routes
        if (location == '/request-form' || location == '/request-history') {
          if (user.role != UserRole.student) {
            return '/dashboard';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/letter-templates',
        builder: (context, state) => const LetterTemplatesScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/request-form',
        builder: (context, state) => const RequestFormScreen(),
      ),
      GoRoute(
        path: '/request-history',
        builder: (context, state) => const RequestHistoryScreen(),
      ),
    ],
  );
});
