import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_mobile/screens/staff/request_detail_screen.dart';
import '../../models/request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/staff_dashboard_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
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
                                'Manage requests and document templates',
                                style: ThemeConfig.bodyMedium.copyWith(
                                  color: ThemeConfig.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.work,
                          size: 48,
                          color: ThemeConfig.primaryBlue.withOpacity(0.7),
                        ),
                      ],
                    ),
                  );
                },
              ),              const SizedBox(height: ThemeConfig.spaceLarge),

              // Quick Actions Section
              const SectionHeader(
                title: 'Quick Actions',
                subtitle: 'Manage your work',
              ),
              const SizedBox(height: ThemeConfig.spaceSmall),
              
              Row(
                children: [
                  Expanded(
                    child: ModernCard(
                      child: InkWell(
                        onTap: () => context.push('/letter-templates'),
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        child: Padding(
                          padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
                                decoration: BoxDecoration(
                                  color: ThemeConfig.accentTeal.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                                ),
                                child: const Icon(
                                  Icons.description,
                                  color: ThemeConfig.accentTeal,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceSmall),
                              const Text(
                                'Templates',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: ThemeConfig.spaceMedium),
                  Expanded(
                    child: ModernCard(
                      child: InkWell(
                        onTap: () => context.push('/staff/my-created-letters'),
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        child: Padding(
                          padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
                                decoration: BoxDecoration(
                                  color: ThemeConfig.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                                ),
                                child: const Icon(
                                  Icons.folder_outlined,
                                  color: ThemeConfig.primaryBlue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceSmall),
                              const Text(
                                'My Letters',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: ThemeConfig.spaceLarge),
              // Requests Section
              const SectionHeader(
                title: 'Document Requests',
                subtitle: 'Review and process student requests',
              ),
              const SizedBox(height: ThemeConfig.spaceSmall),

              SizedBox(
                height: 500,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Pending'),
                          Tab(text: 'Processed'),
                        ],
                      ),
                      const SizedBox(height: ThemeConfig.spaceMedium),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildPendingRequestsTab(ref),
                            _buildProcessedRequestsTab(ref),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),        ),
      ),
    );
  }

  Widget _buildPendingRequestsTab(WidgetRef ref) {
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider);

    return pendingRequestsAsync.when(
      data: (pendingRequests) {
        if (pendingRequests.isEmpty) {
          return const Center(
            child: Text('No pending requests found'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pendingRequestsProvider);
          },
          child: ListView.builder(
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final request = pendingRequests[index];
              return ModernCard(
                child: ListTile(
                  title: Text(
                    '${request.type.name.toUpperCase()} Request',
                    style: ThemeConfig.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: ThemeConfig.spaceSmall),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Requested by',
                            style: ThemeConfig.bodySmall.copyWith(
                              color: ThemeConfig.textSecondary,
                            ),
                          ),
                          Text(
                            _formatUserName(request),
                            style: ThemeConfig.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: ThemeConfig.spaceSmall),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created',
                            style: ThemeConfig.bodySmall.copyWith(
                              color: ThemeConfig.textSecondary,
                            ),
                          ),
                          Text(
                            request.createdAt.toString().split('.')[0],
                            style: ThemeConfig.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            RequestDetailScreen(request: request),
                      ),
                    );

                    if (result == true) {
                      ref.invalidate(pendingRequestsProvider);
                      await ref
                          .read(approvedRequestsProvider.notifier)
                          .refresh();
                    }
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error loading requests: ${error.toString()}'),
      ),
    );
  }

  Widget _buildProcessedRequestsTab(WidgetRef ref) {
    final approvedRequestsState = ref.watch(approvedRequestsProvider);
    final notifier = ref.read(approvedRequestsProvider.notifier);

    if (approvedRequestsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${approvedRequestsState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (approvedRequestsState.requests.isEmpty &&
        !approvedRequestsState.isLoading) {
      return const Center(
        child: Text('No processed requests found'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              approvedRequestsState.hasMore &&
              !approvedRequestsState.isLoading) {
            notifier.loadMore();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: approvedRequestsState.requests.length +
              (approvedRequestsState.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == approvedRequestsState.requests.length) {
              // Loading indicator at the bottom
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final request = approvedRequestsState.requests[index];
            return ModernCard(
              child: ListTile(
                title: Text(
                  '${request.type.name.toUpperCase()} Request',
                  style: ThemeConfig.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: ThemeConfig.spaceSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requested by',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                        Text(
                          _formatUserName(request),
                          style: ThemeConfig.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: ThemeConfig.spaceSmall),
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          'Status',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                        StatusChip(
                          status: request.status.name,
                          isLarge: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: ThemeConfig.spaceSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Updated',
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                        Text(
                          request.updatedAt.toString().split('.')[0],
                          style: ThemeConfig.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          RequestDetailScreen(request: request),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatUserName(Request request) {
    final userName = request.userName ?? request.userId ?? 'Unknown';
    if (request.userStudentId != null && request.userStudentId!.isNotEmpty) {
      return '$userName (${request.userStudentId})';
    }
    return userName;
  }
}
