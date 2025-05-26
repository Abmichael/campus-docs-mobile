import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../models/request.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/staff/dashboard_screen.dart';
import '../screens/staff/letter_templates_screen.dart';
import '../screens/staff/request_detail_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/user_management_screen.dart';
import '../screens/admin/audit_logs_screen.dart';
import '../screens/admin/system_settings_screen.dart';
import '../screens/student/dashboard_screen.dart' as student;
import '../screens/student/request_form_screen.dart';
import '../screens/student/request_history_screen.dart';
import '../screens/student/my_documents_screen.dart';
import '../screens/student/letter_detail_screen.dart';
import '../screens/student/help_support_screen.dart';
import '../screens/staff/my_created_letters_screen.dart';
import '../screens/common/settings_screen.dart';

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
      }      // If logged in and trying to access auth routes, redirect based on onboarding status
      if (isLoggedIn &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/forgot-password' ||
              state.matchedLocation == '/')) {
        final user = authState.user!;
        final hasSeenOnboarding = authState.hasSeenOnboarding;

        // If user hasn't seen onboarding yet, redirect to onboarding screen
        if (!hasSeenOnboarding) {
          return '/onboarding';
        }

        // Redirect to appropriate dashboard based on user role
        switch (user.role) {
          case UserRole.administrator:
            return '/admin/dashboard';
          case UserRole.staff:
            return '/dashboard';
          case UserRole.student:
            return '/student/dashboard';
        }
      }// Check role-based access for protected routes
      if (isLoggedIn) {
        final user = authState.user!;
        final location = state.matchedLocation; // Admin-only routes
        if (location.startsWith('/admin') || location == '/users') {
          if (user.role != UserRole.administrator) {
            return '/student/dashboard';
          }
        }

        // Staff-only routes
        if (location == '/dashboard' || location == '/letter-templates') {
          if (user.role != UserRole.staff &&
              user.role != UserRole.administrator) {
            return '/student/dashboard';
          }
        }

        // Student-only routes
        if (location.startsWith('/student')) {
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
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/admin/audit-logs',
        builder: (context, state) => const AuditLogsScreen(),
      ),
      GoRoute(
        path: '/admin/system-settings',
        builder: (context, state) => const SystemSettingsScreen(),
      ),
      // Student routes
      GoRoute(
        path: '/student/dashboard',
        builder: (context, state) => const student.DashboardScreen(),
      ),
      GoRoute(
        path: '/student/request-form',
        builder: (context, state) => const RequestFormScreen(),
      ),      GoRoute(
        path: '/student/request-history',
        builder: (context, state) => const RequestHistoryScreen(),
      ),
      GoRoute(
        path: '/student/my-documents',
        builder: (context, state) => const MyDocumentsScreen(),
      ),      GoRoute(
        path: '/student/help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/student/letter/:id',
        builder: (context, state) {
          final letterId = state.pathParameters['id']!;
          return LetterDetailScreen(letterId: letterId);
        },
      ),
      // Staff letter routes  
      GoRoute(
        path: '/staff/my-created-letters',
        builder: (context, state) => const MyCreatedLettersScreen(),
      ),
      GoRoute(
        path: '/staff/letter/:id',
        builder: (context, state) {
          final letterId = state.pathParameters['id']!;
          return LetterDetailScreen(letterId: letterId);
        },
      ),
      // Common routes
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Staff routes
      GoRoute(
        path: '/staff/request-detail',
        builder: (context, state) {
          final request = state.extra as Request;
          return RequestDetailScreen(request: request);
        },
      ),
    ],
  );
});
