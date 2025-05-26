import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  UserRole? _selectedRole;
  @override
  void initState() {
    super.initState();
    // Pre-select the user's current role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        setState(() {
          _selectedRole = user.role;
        });
      }
    });
  }

  void _handleRoleSelection(UserRole role) {
    setState(() => _selectedRole = role);
  }  void _handleContinue() {
    if (_selectedRole != null) {
      // Mark onboarding as completed
      ref.read(authProvider.notifier).markOnboardingCompleted();
      
      // Navigate to appropriate dashboard based on selected role
      switch (_selectedRole!) {
        case UserRole.student:
          context.go('/student/dashboard');
          break;
        case UserRole.staff:
          context.go('/dashboard');
          break;
        case UserRole.administrator:
          context.go('/admin');
          break;
      }
    }
  }  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: ThemeConfig.spaceLarge),

                // Header
                const Icon(
                  Icons.school,
                  size: 80,
                  color: ThemeConfig.primaryBlue,
                ),
                const SizedBox(height: ThemeConfig.spaceMedium),
                Text(
                  user != null 
                      ? 'Welcome back, ${user.name}!'
                      : 'Welcome to MIT Mobile',
                  style: ThemeConfig.headlineLarge.copyWith(
                    color: ThemeConfig.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ThemeConfig.spaceSmall),
                Text(
                  user != null
                      ? 'Here\'s what you can do in the system:'
                      : 'Your all-in-one platform for academic document management',
                  style: ThemeConfig.bodyLarge.copyWith(
                    color: ThemeConfig.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ThemeConfig.spaceLarge),

                // Role Card (only for user's role)
                if (user != null) ...[
                  _buildRoleCardForUser(user.role),
                  const SizedBox(height: ThemeConfig.spaceLarge),
                ] else ...[
                  // If no user (shouldn't happen, but fallback)
                  Text(
                    'Choose your role to see what you can do in the system:',
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: ThemeConfig.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ThemeConfig.spaceMedium),
                  _RoleCard(
                    role: UserRole.student,
                    title: 'Student/Alumni',
                    description: 'What you can do in the system',
                    features: const [
                      'Submit document requests (transcripts, letters)',
                      'Track request status in real-time',
                      'View and download completed documents',
                      'Access request history and notifications',
                    ],
                    isSelected: _selectedRole == UserRole.student,
                    onTap: () => _handleRoleSelection(UserRole.student),
                  ),
                  const SizedBox(height: ThemeConfig.spaceLarge),
                ],

                // Continue Button
                ActionButton(
                  onPressed: _selectedRole != null ? _handleContinue : null,
                  text: 'Get Started',
                  icon: Icons.arrow_forward,
                ),
                const SizedBox(height: ThemeConfig.spaceLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildRoleCardForUser(UserRole userRole) {
    String title;
    List<String> features;
    
    switch (userRole) {
      case UserRole.student:
        title = 'Student/Alumni';
        features = const [
          'Submit document requests (transcripts, letters)',
          'Track request status in real-time',
          'View and download completed documents',
          'Access request history and notifications',
        ];
        break;
      case UserRole.staff:
        title = 'Staff';
        features = const [
          'Review and approve student requests',
          'Create and manage letter templates',
          'Generate official documents for students',
          'Process document requests efficiently',
        ];
        break;
      case UserRole.administrator:
        title = 'Administrator';
        features = const [
          'Manage user accounts and permissions',
          'Monitor system activity with audit logs',
          'Configure system settings and templates',
          'View comprehensive system statistics',
        ];
        break;
    }

    return _RoleCard(
      role: userRole,
      title: title,
      description: 'What you can do in the system',
      features: features,
      isSelected: true,
      onTap: () => _handleRoleSelection(userRole),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String description;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.features,
    required this.isSelected,
    required this.onTap,
  });  @override
  Widget build(BuildContext context) {
    return ModernCard(
      backgroundColor:
          isSelected ? ThemeConfig.primaryBlue.withOpacity(0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? ThemeConfig.primaryBlue
                  : ThemeConfig.borderLight,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForRole(role),
                    color: isSelected
                        ? ThemeConfig.primaryBlue
                        : ThemeConfig.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(width: ThemeConfig.spaceSmall),
                  Text(
                    title,
                    style: ThemeConfig.headlineSmall.copyWith(
                      color: isSelected
                          ? ThemeConfig.primaryBlue
                          : ThemeConfig.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: ThemeConfig.primaryBlue,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: ThemeConfig.spaceSmall),
              Text(
                description,
                style: ThemeConfig.bodyMedium.copyWith(
                  color: ThemeConfig.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: ThemeConfig.spaceSmall),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: ThemeConfig.spaceXSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: isSelected
                          ? ThemeConfig.primaryBlue
                          : ThemeConfig.textSecondary,
                    ),
                    const SizedBox(width: ThemeConfig.spaceSmall),
                    Expanded(
                      child: Text(
                        feature,
                        style: ThemeConfig.bodySmall.copyWith(
                          color: ThemeConfig.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school;
      case UserRole.staff:
        return Icons.work;
      case UserRole.administrator:
        return Icons.admin_panel_settings;
    }
  }
}
