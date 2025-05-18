import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../services/admin_service.dart';

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
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(adminServiceProvider);
  final data = await service.getAuditLogs();
  return data.cast<Map<String, dynamic>>();
});

final systemSettingsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(adminServiceProvider);
  return service.getSystemSettings();
});
