import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/staff_dashboard_provider.dart';
import '../../providers/user_profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),      body: Padding(
        padding: const EdgeInsets.all(16.0),        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            Consumer(
              builder: (context, ref, child) {
                final greeting = ref.watch(userGreetingProvider);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pending Requests',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),Expanded(
              child: pendingRequestsAsync.when(
                data: (pendingRequests) {
                  if (pendingRequests.isEmpty) {
                    return const Center(
                      child: Text('No pending requests found'),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(pendingRequestsProvider.future),
                    child: ListView.builder(
                      itemCount: pendingRequests.length,
                      itemBuilder: (context, index) {
                        final request = pendingRequests[index];
                        return Card(
                          child: ListTile(
                            title: Text('${request.type.name.toUpperCase()} Request'),
                            subtitle: Text(
                              'Created: ${request.createdAt.toString().split('.')[0]}',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // TODO: Navigate to request details
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Error loading requests: ${error.toString()}'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/letter-templates'),
        child: const Icon(Icons.description),
      ),
    );
  }
}
