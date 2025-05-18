import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/request.dart';

class RequestHistoryScreen extends ConsumerWidget {
  const RequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual data provider
    final requests = [
      Request(
        id: '1',
        type: RequestType.letter,
        status: RequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
        notes: 'Request for enrollment verification',
      ),
      Request(
        id: '2',
        type: RequestType.transcript,
        status: RequestStatus.approved,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Official transcript request',
      ),
      Request(
        id: '3',
        type: RequestType.other,
        status: RequestStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Special request for scholarship application',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Request History')),
      body: ListView.builder(
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
