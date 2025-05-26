import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardStatsProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Container(
                  decoration: BoxDecoration(
                    gradient: ThemeConfig.softBlueGradient,
                    borderRadius:
                        BorderRadius.circular(ThemeConfig.radiusMedium),
                    boxShadow: ThemeConfig.cardShadow,
                  ),
                  padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Dashboard',
                              style: ThemeConfig.headlineMedium.copyWith(
                                color: ThemeConfig.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: ThemeConfig.spaceSmall),
                            Text(
                              'Manage users, monitor system activity, and configure settings',
                              style: ThemeConfig.bodyMedium.copyWith(
                                color: ThemeConfig.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.admin_panel_settings,
                        size: 48,
                        color: ThemeConfig.primaryBlue.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: ThemeConfig.spaceLarge),

                // Statistics Section
                const SectionHeader(
                  title: 'System Statistics',
                  subtitle: 'Overview of current system metrics',
                ),
                const SizedBox(height: ThemeConfig.spaceSmall),
                statsAsync.when(
                  data: (stats) => GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: ThemeConfig.spaceMedium,
                    mainAxisSpacing: ThemeConfig.spaceMedium,
                    childAspectRatio: 0.7,
                    children: [
                      _buildStatCard(
                        'Total Users',
                        stats['totalUsers'] ?? 0,
                        Icons.people,
                        ThemeConfig.secondaryBlue,
                      ),
                      _buildStatCard(
                        'Active Requests',
                        stats['activeRequests'] ?? 0,
                        Icons.pending_actions,
                        ThemeConfig.warningOrange,
                      ),
                      _buildStatCard(
                        'Pending',
                        stats['pendingApprovals'] ?? 0,
                        Icons.approval,
                        ThemeConfig.errorRed,
                      ),
                    ],
                  ),
                  loading: () =>
                      const LoadingWidget(message: 'Loading statistics...'),
                  error: (error, stack) => ModernCard(
                    backgroundColor: ThemeConfig.errorRed.withOpacity(0.1),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: ThemeConfig.errorRed,
                        ),
                        const SizedBox(width: ThemeConfig.spaceSmall),
                        Expanded(
                          child: Text(
                            'Error loading statistics: ${error.toString()}',
                            style: ThemeConfig.bodyMedium.copyWith(
                              color: ThemeConfig.errorRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: ThemeConfig.spaceLarge),

                // Quick Actions Section
                const SectionHeader(
                  title: 'Quick Actions',
                  subtitle: 'Common administrative tasks',
                ),
                const SizedBox(height: ThemeConfig.spaceSmall),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: ThemeConfig.spaceMedium,
                  mainAxisSpacing: ThemeConfig.spaceMedium,
                  childAspectRatio: 0.8,
                  children: [
                    _buildActionCard(
                      'User Management',
                      Icons.people,
                      ThemeConfig.secondaryBlue,
                      'Manage user accounts and permissions',
                      () => context.push('/users'),
                    ),
                    _buildActionCard(
                      'Audit Logs',
                      Icons.history,
                      ThemeConfig.successGreen,
                      'View system activity and logs',
                      () => context.push('/admin/audit-logs'),
                    ),
                    _buildActionCard(
                      'System Settings',
                      Icons.settings,
                      ThemeConfig.lightBlue,
                      'Configure system parameters',
                      () => context.push('/admin/system-settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int value,
    IconData icon,
    Color color,
  ) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Icon(
                icon,
                size: 28, // Reduced size
                color: color,
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceXSmall),
            Flexible(
              child: Text(
                title,
                style: ThemeConfig.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ThemeConfig.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceXSmall),
            FittedBox(
              child: Text(
                value.toString(),
                style: ThemeConfig.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return ModernCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConfig.spaceXSmall),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                ),
                child: Icon(
                  icon,
                  size: 24, // Reduced size
                  color: color,
                ),
              ),
              const SizedBox(height: ThemeConfig.spaceSmall),
              Flexible(
                child: Text(
                  title,
                  style: ThemeConfig.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ThemeConfig.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: ThemeConfig.spaceXSmall),
              Flexible(
                flex: 2,
                child: Text(
                  description,
                  style: ThemeConfig.bodySmall.copyWith(
                    color: ThemeConfig.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
