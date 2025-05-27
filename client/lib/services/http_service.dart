import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Centralized HTTP service to handle all API requests
/// This ensures consistent base URL and authentication token handling across the app
class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  /// Get the base URL from configuration
  Future<String> get _baseUrl => ApiConfig.baseUrl;

  /// Get the authentication token
  Future<String?> get _token => ApiConfig.token;

  /// Build headers with authentication
  Future<Map<String, String>> _buildHeaders() async {
    final token = await _token;
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// Build full URL from endpoint
  Future<Uri> _buildUrl(String endpoint) async {
    final baseUrl = await _baseUrl;
    // Ensure endpoint starts with /
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$cleanEndpoint');
  }

  /// Perform GET request
  Future<http.Response> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = await _buildUrl(endpoint);
    final uriWithQuery = queryParams != null 
        ? uri.replace(queryParameters: queryParams)
        : uri;
    final headers = await _buildHeaders();
    
    return await http.get(uriWithQuery, headers: headers);
  }

  /// Perform POST request
  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = await _buildUrl(endpoint);
    final headers = await _buildHeaders();
    final encodedBody = body != null ? json.encode(body) : null;
    
    return await http.post(uri, headers: headers, body: encodedBody);
  }

  /// Perform PATCH request
  Future<http.Response> patch(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = await _buildUrl(endpoint);
    final headers = await _buildHeaders();
    final encodedBody = body != null ? json.encode(body) : null;
    
    return await http.patch(uri, headers: headers, body: encodedBody);
  }

  /// Perform PUT request
  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = await _buildUrl(endpoint);
    final headers = await _buildHeaders();
    final encodedBody = body != null ? json.encode(body) : null;
    
    return await http.put(uri, headers: headers, body: encodedBody);
  }

  /// Perform DELETE request
  Future<http.Response> delete(String endpoint) async {
    final uri = await _buildUrl(endpoint);
    final headers = await _buildHeaders();
    
    return await http.delete(uri, headers: headers);
  }
}
