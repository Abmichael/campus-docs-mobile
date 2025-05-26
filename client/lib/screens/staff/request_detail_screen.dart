import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/request.dart';
import '../../services/request_service.dart';
import 'create_letter_screen.dart';

class RequestDetailScreen extends ConsumerStatefulWidget {
  final Request request;

  const RequestDetailScreen({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends ConsumerState<RequestDetailScreen> {
  bool _isProcessing = false;

  Future<void> _updateRequestStatus(RequestStatus status) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final requestService = RequestService();
      await requestService.updateRequestStatus(widget.request.id, status);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request ${status == RequestStatus.approved ? 'approved' : 'rejected'} successfully'),
            backgroundColor: status == RequestStatus.approved ? Colors.green : Colors.red,
          ),
        );
        context.pop(true); // Pop with result to refresh the list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating request: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${request.type.name.toUpperCase()} Request',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),                          const SizedBox(height: 8),
                          _buildInfoRow('Requested by', _formatUserName(request)),
                          _buildInfoRow('Status', _getStatusText(request.status)),
                          _buildInfoRow('Created', _formatDate(request.createdAt)),
                          _buildInfoRow('Updated', _formatDate(request.updatedAt)),
                          if (request.notes != null && request.notes!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notes:',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    request.notes!,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),                  const SizedBox(height: 32),
                  if (request.status == RequestStatus.pending)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateRequestStatus(RequestStatus.approved),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('APPROVE'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateRequestStatus(RequestStatus.rejected),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('REJECT'),
                          ),
                        ),
                      ],
                    ),
                  // Show status information for processed requests
                  if (request.status != RequestStatus.pending)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: _getStatusColor(request.status),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getStatusIcon(request.status),
                            color: _getStatusColor(request.status),
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Request ${_getStatusText(request.status)}',
                            style: TextStyle(
                              color: _getStatusColor(request.status),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Updated: ${_formatDate(request.updatedAt)}',
                            style: TextStyle(
                              color: _getStatusColor(request.status),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Letter creation button for staff if request type is letter
                  if (request.type == RequestType.letter &&
                      (request.status == RequestStatus.pending || request.status == RequestStatus.approved))
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Create Letter'),
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CreateLetterScreen(request: request),
                              ),
                            );
                            if (result == true && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Letter created successfully')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
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

  String _getStatusText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.completed:
        return 'Completed';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.hourglass_empty;
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.completed:
        return Icons.done_all;
    }
  }
}
