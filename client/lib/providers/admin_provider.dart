import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../services/admin_service.dart';
import '../models/audit_log.dart';
import '../models/system_settings.dart';

final adminServiceProvider = Provider((ref) {
  final dio = Dio();
  return AdminService(dio);
});

final dashboardStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final service = ref.watch(adminServiceProvider);
  final data = await service.getDashboardStats();
  return {
    'totalUsers': data.totalUsers,
    'activeRequests': data.activeRequests,
    'pendingApprovals': data.pendingApprovals,
  };
});

final auditLogsProvider =
    FutureProvider<List<AuditLog>>((ref) async {
  final service = ref.watch(adminServiceProvider);
  return await service.getAuditLogs();
});

final systemSettingsProvider =
    FutureProvider<SystemSettings>((ref) async {
  final service = ref.watch(adminServiceProvider);
  return await service.getSystemSettings();
});
