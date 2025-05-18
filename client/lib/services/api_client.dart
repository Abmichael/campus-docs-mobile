import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/letter_template.dart';
import '../models/request.dart';

part 'api_client.g.dart';
part 'api_client.freezed.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) {
    dio.options = BaseOptions(
      baseUrl: baseUrl ?? ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add error interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error:
                    'Connection timed out. Please check your internet connection.',
              ),
            );
          }

          if (e.type == DioExceptionType.connectionError) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error:
                    'Unable to connect to the server. Please try again later.',
              ),
            );
          }

          // Handle API error responses
          if (e.response != null) {
            final statusCode = e.response?.statusCode;
            final data = e.response?.data;

            String errorMessage = 'An error occurred';
            if (data is Map<String, dynamic> && data.containsKey('error')) {
              errorMessage = data['error'];
            } else if (statusCode == 401) {
              errorMessage = 'Unauthorized. Please login again.';
            } else if (statusCode == 403) {
              errorMessage =
                  'Access denied. You don\'t have permission to perform this action.';
            } else if (statusCode == 404) {
              errorMessage = 'Resource not found.';
            } else if (statusCode == 500) {
              errorMessage = 'Server error. Please try again later.';
            }

            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: errorMessage,
                response: e.response,
              ),
            );
          }

          return handler.next(e);
        },
      ),
    );

    return _ApiClient(dio, baseUrl: baseUrl);
  }

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() Map<String, dynamic> credentials);

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/letters/templates')
  Future<List<LetterTemplate>> getLetterTemplates();

  @GET('/requests')
  Future<List<Request>> getRequests();

  @POST('/requests')
  Future<Request> createRequest(@Body() Request request);

  @GET('/users')
  Future<List<User>> getUsers();

  @GET('/users/{id}')
  Future<User> getUser(@Path('id') String id);
}

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({required String token, required User user}) =
      _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
