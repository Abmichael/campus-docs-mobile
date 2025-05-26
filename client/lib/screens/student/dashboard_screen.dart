import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_dashboard_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../config/theme_config.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentRequestsAsync = ref.watch(recentRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
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
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(recentRequestsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
            ThemeConfig.spaceMedium,
            ThemeConfig.spaceMedium,
            ThemeConfig.spaceMedium,
            ThemeConfig.spaceMedium * 5, // Extra space for FAB
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Consumer(
                builder: (context, ref, child) {
                  final greeting = ref.watch(userGreetingProvider);
                  return Container(
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
                                greeting,
                                style: ThemeConfig.headlineMedium.copyWith(
                                  color: ThemeConfig.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceSmall),
                              Text(
                                'Manage your academic documents and requests',
                                style: ThemeConfig.bodyMedium.copyWith(
                                  color: ThemeConfig.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.school,
                          size: 48,
                          color: ThemeConfig.primaryBlue.withOpacity(0.7),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: ThemeConfig.spaceLarge),

              // Quick Actions
              const SectionHeader(
                title: 'Quick Actions',
                subtitle: 'Common tasks and shortcuts',
              ),
              _buildQuickActions(context),

              const SizedBox(height: ThemeConfig.spaceLarge),

              // Recent Requests
              const SectionHeader(
                title: 'Recent Requests',
                subtitle: 'Your latest document requests',
              ),
              const SizedBox(height: ThemeConfig.spaceSmall),

              recentRequestsAsync.when(
                data: (recentRequests) {
                  if (recentRequests.isEmpty) {
                    return const EmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'No Recent Requests',
                      message:
                          'You haven\'t made any requests yet. Start by creating a new request.',
                      actionText: 'Create Request',
                    );
                  }
                  return Column(
                    children: recentRequests
                        .map((request) => _RequestCard(request: request))
                        .toList(),
                  );
                },
                loading: () =>
                    const LoadingWidget(message: 'Loading requests...'),
                error: (error, stackTrace) => ModernCard(
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
                          'Error loading requests: ${error.toString()}',
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.errorRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/student/request-form'),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
        backgroundColor: ThemeConfig.accentTeal,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: ThemeConfig.spaceMedium,
      crossAxisSpacing: ThemeConfig.spaceMedium,
      childAspectRatio: 0.8,
      children: [
        _ActionCard(
          icon: Icons.history,
          title: 'Request History',
          subtitle: 'View all requests',
          onTap: () => context.push('/student/request-history'),
        ),        _ActionCard(
          icon: Icons.description,
          title: 'My Documents',
          subtitle: 'Manage documents',
          onTap: () => context.push('/student/my-documents'),
        ),
        _ActionCard(
          icon: Icons.person,
          title: 'Profile',
          subtitle: 'Update profile',
          onTap: () => context.push('/settings'),
        ),
        _ActionCard(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get assistance',
          onTap: () => context.push('/student/help-support'),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
              ),
              child: Icon(
                icon,
                size: 24,
                color: ThemeConfig.primaryBlue,
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceSmall),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: ThemeConfig.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceXSmall),
            Flexible(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: ThemeConfig.bodySmall.copyWith(
                  color: ThemeConfig.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Request request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: ThemeConfig.spaceMedium),
      onTap: () {
        // TODO: Navigate to request details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${request.type.name.toUpperCase()} Request',
                  style: ThemeConfig.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              StatusChip(status: request.status.name),
            ],
          ),
          const SizedBox(height: ThemeConfig.spaceSmall),
          InfoRow(
            label: 'Created',
            value: _formatDate(request.createdAt),
            icon: Icons.calendar_today,
          ),
          InfoRow(
            label: 'Updated',
            value: _formatDate(request.updatedAt),
            icon: Icons.update,
          ),
          if (request.notes != null && request.notes!.isNotEmpty) ...[
            const SizedBox(height: ThemeConfig.spaceSmall),
            Text(
              'Notes: ${request.notes}',
              style: ThemeConfig.bodySmall.copyWith(
                color: ThemeConfig.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
