import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/dashboard_stats.dart';
import '../models/audit_log.dart';
import '../models/system_settings.dart';

part 'admin_service.g.dart';

@RestApi()
abstract class AdminService {
  factory AdminService(Dio dio, {String? baseUrl}) {
    dio.options.baseUrl = baseUrl ?? ApiConfig.baseUrl;

    // Add token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await ApiConfig.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired or invalid, clear it
            await ApiConfig.clearToken();
          }
          return handler.next(e);
        },
      ),
    );

    return _AdminService(dio, baseUrl: baseUrl);
  }
  @GET('/admin/stats')
  Future<DashboardStats> getDashboardStats();

  @GET('/admin/audit-logs')
  Future<List<AuditLog>> getAuditLogs();  @GET('/admin/settings')
  Future<SystemSettings> getSystemSettings();

  @PATCH('/admin/settings')
  Future<SystemSettings> updateSystemSettings(
      @Body() Map<String, dynamic> settings);
}
