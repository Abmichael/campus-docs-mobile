import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request.dart';
import '../config/api_config.dart';

class RequestService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<Request>> getRequests() async {
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
