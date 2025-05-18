import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  UserRole? _selectedRole;

  void _handleRoleSelection(UserRole role) {
    setState(() => _selectedRole = role);
  }

  void _handleContinue() {
    if (_selectedRole != null) {
      // TODO: Implement role selection logic
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to MIT Mobile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Please select your role to continue:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _RoleCard(
              role: UserRole.student,
              title: 'Student/Alumni',
              description: 'Access your academic records and request documents',
              isSelected: _selectedRole == UserRole.student,
              onTap: () => _handleRoleSelection(UserRole.student),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              role: UserRole.staff,
              title: 'Staff',
              description: 'Manage letter templates and review requests',
              isSelected: _selectedRole == UserRole.staff,
              onTap: () => _handleRoleSelection(UserRole.staff),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              role: UserRole.administrator,
              title: 'Admiadministratoristrator',
              description: 'Manage users and view audit logs',
              isSelected: _selectedRole == UserRole.administrator,
              onTap: () => _handleRoleSelection(UserRole.administrator),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedRole != null ? _handleContinue : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
