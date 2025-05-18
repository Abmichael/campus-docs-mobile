import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_provider.dart';

class AuditLogsScreen extends ConsumerWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(auditLogsProvider.future),
        child: logsAsync.when(
          data: (logs) => ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ListTile(
                  leading: Icon(
                    _getIconForAction(log['action'] as String),
                    color: _getColorForAction(log['action'] as String),
                  ),
                  title: Text(log['action'] as String),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: ${log['user']}'),
                      Text('Timestamp: ${log['timestamp']}'),
                      if (log['details'] != null)
                        Text('Details: ${log['details']}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
        ),
      ),
    );
  }

  IconData _getIconForAction(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'create':
        return Icons.add;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.info;
    }
  }

  Color _getColorForAction(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Colors.green;
      case 'logout':
        return Colors.orange;
      case 'create':
        return Colors.blue;
      case 'update':
        return Colors.purple;
      case 'delete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
