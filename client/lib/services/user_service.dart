import 'dart:convert';
import '../models/user.dart';
import 'http_service.dart';

class UserService {
  final HttpService _httpService = HttpService();

  Future<List<User>> getUsers() async {
    final response = await _httpService.get('/users');

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
    String? studentId,
  }) async {
    final response = await _httpService.post('/users', body: {
      'name': name,
      'email': email,
      'password': password,
      'role': role.toString().split('.').last,
      if (role == UserRole.student && studentId != null) 'studentId': studentId,
    });

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
    String? studentId,
  }) async {
    final response = await _httpService.patch('/users/$id', body: {
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      if (role == UserRole.student && studentId != null) 'studentId': studentId,
    });

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await _httpService.delete('/users/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
