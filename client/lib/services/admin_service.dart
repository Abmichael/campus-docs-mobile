import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/dashboard_stats.dart';

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
  Future<List<JsonSerializable>> getAuditLogs();

  @GET('/admin/settings')
  Future<Map<String, JsonSerializable>> getSystemSettings();

  @PATCH('/admin/settings')
  Future<Map<String, JsonSerializable>> updateSystemSettings(
      @Body() Map<String, dynamic> settings);
}
