import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/request.dart';
import '../../providers/request_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class RequestHistoryScreen extends ConsumerWidget {
  const RequestHistoryScreen({super.key});  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(requestsProvider.future),
          ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConfig.spaceMedium),
                  child: RefreshIndicator(
                    color: ThemeConfig.primaryBlue,
                    backgroundColor: Colors.white,
                    onRefresh: () => ref.refresh(requestsProvider.future),
                    child: requestsAsync.when(
                      data: (requests) {
                        if (requests.isEmpty) {
                          return Center(
                            child: ModernCard(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    ThemeConfig.spaceLarge),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 64,
                                      color: ThemeConfig.primaryBlue
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(
                                        height: ThemeConfig.spaceMedium),
                                    const Text(
                                      'No requests found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeConfig.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: ThemeConfig.spaceSmall),
                                    const Text(
                                      'You haven\'t made any requests yet.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeConfig.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(
                              bottom: ThemeConfig.spaceLarge),
                          itemCount: requests.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: ThemeConfig.spaceSmall),
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return _buildRequestCard(request);
                          },
                        );
                      },
                      loading: () =>
                          const LoadingWidget(message: 'Loading requests...'),
                      error: (error, stackTrace) => Center(
                        child: ModernCard(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(ThemeConfig.spaceLarge),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: ThemeConfig.errorRed,
                                ),
                                const SizedBox(height: ThemeConfig.spaceMedium),
                                const Text(
                                  'Error loading requests',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeConfig.errorRed,
                                  ),
                                ),
                                const SizedBox(height: ThemeConfig.spaceSmall),
                                Text(
                                  error.toString(),
                                  style: const TextStyle(
                                    color: ThemeConfig.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Request request) {
    return ModernCard(
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(ThemeConfig.spaceMedium),
          childrenPadding: const EdgeInsets.fromLTRB(
            ThemeConfig.spaceMedium,
            0,
            ThemeConfig.spaceMedium,
            ThemeConfig.spaceMedium,
          ),
          leading: Container(
            padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
            decoration: BoxDecoration(
              color: _getStatusColor(request.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
            ),
            child: Icon(
              _getStatusIcon(request.status),
              color: _getStatusColor(request.status),
              size: 20,
            ),
          ),
          title: Text(
            '${request.type.name.toUpperCase()} Request',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ThemeConfig.textPrimary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: ThemeConfig.spaceXSmall),
              Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConfig.spaceSmall,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(request.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.status.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConfig.spaceXSmall),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: ThemeConfig.textSecondary,
                  ),
                  const SizedBox(width: ThemeConfig.spaceXSmall),
                  Text(
                    _formatTimestamp(request.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
              decoration: BoxDecoration(
                color: ThemeConfig.paleGray,
                borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Created',
                    value: _formatDate(request.createdAt),
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: ThemeConfig.spaceSmall),
                  _InfoRow(
                    label: 'Last Updated',
                    value: _formatDate(request.updatedAt),
                    icon: Icons.update,
                  ),
                  if (request.notes != null && request.notes!.isNotEmpty) ...[
                    const SizedBox(height: ThemeConfig.spaceSmall),
                    const Divider(color: ThemeConfig.borderLight),
                    const SizedBox(height: ThemeConfig.spaceSmall),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.notes,
                          size: 16,
                          color: ThemeConfig.textSecondary,
                        ),
                        const SizedBox(width: ThemeConfig.spaceSmall),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ThemeConfig.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                request.notes!,
                                style: const TextStyle(
                                  color: ThemeConfig.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return ThemeConfig.warningOrange;
      case RequestStatus.approved:
        return ThemeConfig.successGreen;
      case RequestStatus.rejected:
        return ThemeConfig.errorRed;
      case RequestStatus.completed:
        return ThemeConfig.primaryBlue;
    }
  }

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.schedule;
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.completed:
        return Icons.task_alt;
    }
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoRow({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: ThemeConfig.textSecondary,
          ),
          const SizedBox(width: ThemeConfig.spaceSmall),
        ],
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: ThemeConfig.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: ThemeConfig.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
