import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/request.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_dashboard_provider.dart';
import '../../providers/user_profile_provider.dart';

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
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final greeting = ref.watch(userGreetingProvider);
                return Text(
                  greeting,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildQuickActions(context),            const SizedBox(height: 24),
            const Text(
              'Recent Requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            recentRequestsAsync.when(              data: (recentRequests) {
                if (recentRequests.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('No recent requests found'),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(recentRequestsProvider.future),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: recentRequests.map((request) => _RequestCard(request: request)).toList(),
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Error loading requests: ${error.toString()}'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/student/request-form'),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _ActionCard(
          icon: Icons.history,
          title: 'Request History',
          onTap: () => context.push('/student/request-history'),
        ),
        _ActionCard(
          icon: Icons.description,
          title: 'My Documents',
          onTap: () {
            // TODO: Implement documents screen
          },
        ),
        _ActionCard(
          icon: Icons.person,
          title: 'Profile',
          onTap: () {
            // TODO: Implement profile screen
          },
        ),
        _ActionCard(
          icon: Icons.help,
          title: 'Help & Support',
          onTap: () {
            // TODO: Implement help screen
          },
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text('${request.type.name.toUpperCase()} Request'),
        subtitle: Text(
          'Status: ${request.status.name.toUpperCase()}',
          style: TextStyle(
            color: _getStatusColor(request.status),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to request details
        },
      ),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.completed:
        return Colors.blue;
    }
  }
}
