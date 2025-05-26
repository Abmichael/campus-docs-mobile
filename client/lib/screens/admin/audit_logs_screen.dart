import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';
import '../../models/audit_log.dart';

class AuditLogsScreen extends ConsumerWidget {
  const AuditLogsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: ThemeConfig.headerGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Audit Logs',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref.refresh(auditLogsProvider.future),
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: ThemeConfig.spaceMedium),
                  child: RefreshIndicator(
                    color: ThemeConfig.primaryBlue,
                    backgroundColor: Colors.white,
                    onRefresh: () => ref.refresh(auditLogsProvider.future),
                    child: logsAsync.when(
                      data: (logs) {
                        if (logs.isEmpty) {
                          return Center(
                            child: ModernCard(
                              child: Padding(
                                padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 64,
                                      color: ThemeConfig.primaryBlue.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: ThemeConfig.spaceMedium),
                                    const Text(
                                      'No audit logs found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ThemeConfig.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: ThemeConfig.spaceLarge),
                          itemCount: logs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: ThemeConfig.spaceSmall),
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            return _buildLogCard(log);
                          },
                        );
                      },
                      loading: () => const LoadingWidget(message: 'Loading audit logs...'),
                      error: (error, stack) => Center(
                        child: ModernCard(
                          child: Padding(
                            padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
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
                                  'Error loading audit logs',
                                  style: TextStyle(
                                    fontSize: 16,
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
  Widget _buildLogCard(AuditLog log) {
    final action = log.action;
    final timestamp = log.timestamp;
    final user = log.user;
    final details = log.details?.toString();

    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
              decoration: BoxDecoration(
                color: _getColorForAction(action).withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
              ),
              child: Icon(
                _getIconForAction(action),
                color: _getColorForAction(action),
                size: 20,
              ),
            ),
            const SizedBox(width: ThemeConfig.spaceMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeConfig.textPrimary,
                    ),
                  ),
                  const SizedBox(height: ThemeConfig.spaceXSmall),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: ThemeConfig.textSecondary,
                      ),
                      const SizedBox(width: ThemeConfig.spaceXSmall),
                      Text(
                        user,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ThemeConfig.textSecondary,
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
                        _formatTimestamp(timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: ThemeConfig.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (details != null && details.isNotEmpty) ...[
                    const SizedBox(height: ThemeConfig.spaceSmall),
                    Container(
                      padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
                      decoration: BoxDecoration(
                        color: ThemeConfig.paleGray,
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                      ),
                      child: Text(
                        details,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ThemeConfig.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timestamp;
    }
  }

  IconData _getIconForAction(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'create':
        return Icons.add_circle_outline;
      case 'update':
        return Icons.edit_outlined;
      case 'delete':
        return Icons.delete_outline;
      case 'view':
        return Icons.visibility_outlined;
      case 'download':
        return Icons.download_outlined;
      case 'upload':
        return Icons.upload_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForAction(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return ThemeConfig.successGreen;
      case 'logout':
        return ThemeConfig.warningOrange;
      case 'create':
        return ThemeConfig.primaryBlue;
      case 'update':
        return ThemeConfig.accentTeal;
      case 'delete':
        return ThemeConfig.errorRed;
      case 'view':
        return ThemeConfig.secondaryBlue;
      case 'download':
        return ThemeConfig.darkTeal;
      case 'upload':
        return ThemeConfig.lightBlue;
      default:
        return ThemeConfig.mediumGray;
    }
  }
}
