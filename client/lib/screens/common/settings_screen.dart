import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../config/theme_config.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final currentUser = ref.watch(authProvider).user;    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use Navigator.of(context).pop() instead of the default back behavior
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            if (currentUser != null) ...[
              ModernCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: ThemeConfig.primaryBlue,
                          child: Text(
                            currentUser.name.substring(0, 1).toUpperCase(),
                            style: ThemeConfig.headlineSmall.copyWith(
                              color: ThemeConfig.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: ThemeConfig.spaceMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser.name,
                                style: ThemeConfig.headlineSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceXSmall),
                              Text(
                                currentUser.email,
                                style: ThemeConfig.bodyMedium.copyWith(
                                  color: ThemeConfig.textSecondary,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceXSmall),
                              RoleBadge(role: currentUser.role.name),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ThemeConfig.spaceLarge),
            ],

            // Theme Settings Section
            const SectionHeader(
              title: 'Appearance',
              subtitle: 'Customize the look and feel of the app',
            ),
            const SizedBox(height: ThemeConfig.spaceSmall),
            
            ModernCard(
              child: Column(
                children: [
                _ThemeOption(
                    title: 'Light Mode',
                    subtitle: 'Use light theme',
                    icon: Icons.light_mode,
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () async {
                      await ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
                    },
                  ),
                  const Divider(height: 1),
                  _ThemeOption(
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    icon: Icons.dark_mode,
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () async {
                      await ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
                    },
                  ),
                  const Divider(height: 1),
                  _ThemeOption(
                    title: 'System Default',
                    subtitle: 'Follow system theme settings',
                    icon: Icons.settings_suggest,
                    isSelected: themeMode == ThemeMode.system,
                    onTap: () async {
                      await ref.read(themeProvider.notifier).setTheme(ThemeMode.system);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConfig.spaceLarge),

            // App Information Section
            const SectionHeader(
              title: 'About',
              subtitle: 'App information and support',
            ),
            const SizedBox(height: ThemeConfig.spaceSmall),
            
            ModernCard(
              child: Column(
                children: [
                  _SettingsItem(
                    title: 'Version',
                    subtitle: '1.0.0',
                    icon: Icons.info_outline,
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    icon: Icons.help_outline,
                    onTap: () => _showHelpDialog(context),
                  ),
                  const Divider(height: 1),
                  _SettingsItem(
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => _showPrivacyDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConfig.spaceLarge),

            // Logout Section
            ModernCard(
              backgroundColor: ThemeConfig.errorRed.withOpacity(0.1),
              child: _SettingsItem(
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                icon: Icons.logout,
                iconColor: ThemeConfig.errorRed,
                titleColor: ThemeConfig.errorRed,
                onTap: () => _showLogoutDialog(context, ref),
              ),
            ),

            const SizedBox(height: ThemeConfig.spaceXXLarge),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About MIT Mobile'),
        content: const Text(
          'MIT Mobile is a comprehensive platform for students, staff, and administrators to manage academic documents and requests.\n\nVersion: 1.0.0\nBuilt with Flutter',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'For technical support, please contact:\n\nEmail: support@mit.edu\nPhone: +1 (555) 123-4567\n\nFor account-related issues, please contact your system administrator.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'MIT Mobile respects your privacy. We collect and process personal information only as necessary to provide our services.\n\nFor the complete privacy policy, please visit our website or contact the administration.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            style: TextButton.styleFrom(
              foregroundColor: ThemeConfig.errorRed,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isSelected
        ? ThemeConfig.primaryBlue
        : Theme.of(context).colorScheme.onSurface;
    final subtitleColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? ThemeConfig.primaryBlue : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: titleColor,
          height: 1.4,
          letterSpacing: 0.1,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: subtitleColor,
          height: 1.3,
          letterSpacing: 0.1,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: ThemeConfig.primaryBlue,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConfig.spaceSmall,
        vertical: ThemeConfig.spaceXSmall,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitleColor = titleColor ?? Theme.of(context).colorScheme.onSurface;
    final resolvedSubtitleColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: resolvedTitleColor,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: 0.1,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: resolvedSubtitleColor,
          height: 1.3,
          letterSpacing: 0.1,
        ),
      ),
      trailing: onTap != null 
          ? const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ThemeConfig.textMuted,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConfig.spaceSmall,
        vertical: ThemeConfig.spaceXSmall,
      ),
    );
  }
}
