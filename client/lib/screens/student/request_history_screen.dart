import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/request.dart';
import '../../providers/request_provider.dart';

class RequestHistoryScreen extends ConsumerWidget {
  const RequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Request History')),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(
              child: Text('No requests found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(requestsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  child: ExpansionTile(
                    title: Text('${request.type.name.toUpperCase()} Request'),
                    subtitle: Text(
                      'Status: ${request.status.name.toUpperCase()}',
                      style: TextStyle(
                        color: _getStatusColor(request.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(
                              label: 'Created',
                              value: request.createdAt.toString().split('.')[0],
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              label: 'Last Updated',
                              value: request.updatedAt.toString().split('.')[0],
                            ),
                            if (request.notes != null) ...[
                              const SizedBox(height: 8),
                              _InfoRow(label: 'Notes', value: request.notes!),
                            ],
                          ],
                        ),
                      ),
                    ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
