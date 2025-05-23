import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config/api_config.dart';

class UserService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<User>> getUsers() async {
    final token = await ApiConfig.token;
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final token = await ApiConfig.token;
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'role': role.toString().split('.').last,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser({
    required String id,
    required String name,
    required String email,
    required UserRole role,
  }) async {
    final token = await ApiConfig.token;
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'role': role.toString().split('.').last,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final token = await ApiConfig.token;
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
