import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request.dart';
import '../config/api_config.dart';

class PaginatedRequestsResponse {
  final List<Request> requests;
  final PaginationInfo pagination;

  PaginatedRequestsResponse({
    required this.requests,
    required this.pagination,
  });

  factory PaginatedRequestsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedRequestsResponse(
      requests: (json['requests'] as List<dynamic>)
          .map((json) => Request.fromJson(json))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
    );
  }
}

class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasMore;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasMore,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
    );
  }
}

class RequestService {
  final String baseUrl = ApiConfig.baseUrl;  Future<List<Request>> getRequests() async {
    final token = await ApiConfig.token;
    final response = await http.get(
      Uri.parse('$baseUrl/requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<PaginatedRequestsResponse> getRequestsPaginated({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final token = await ApiConfig.token;
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (status != null) 'status': status,
    };
    
    final uri = Uri.parse('$baseUrl/requests').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PaginatedRequestsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<Request> createRequest(RequestType type, {String? notes}) async {
    final token = await ApiConfig.token;
    final response = await http.post(
      Uri.parse('$baseUrl/requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'type': type.toString().split('.').last,
        'notes': notes,
      }),
    );

    if (response.statusCode == 201) {
      return Request.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create request');
    }
  }

  Future<Request> updateRequestStatus(String id, RequestStatus status) async {
    final token = await ApiConfig.token;
    final response = await http.patch(
      Uri.parse('$baseUrl/requests/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'status': status.toString().split('.').last,
      }),
    );

    if (response.statusCode == 200) {
      return Request.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update request status');
    }
  }
}
