import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/letter_template.dart';
import '../config/api_config.dart';

class LetterTemplateService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<LetterTemplate>> fetchTemplates() async {
    final token = await ApiConfig.token;
    final response = await http.get(
      Uri.parse('$baseUrl/letter-templates'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LetterTemplate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load letter templates');
    }
  }

  Future<List<LetterTemplate>> getTemplates() async {
    final token = await ApiConfig.token;
    final response = await http.get(
      Uri.parse('$baseUrl/letter-templates'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LetterTemplate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load letter templates');
    }
  }

  Future<LetterTemplate> createTemplate({
    required String title,
    required String body,
    required List<String> placeholders,
  }) async {
    final token = await ApiConfig.token;
    final response = await http.post(
      Uri.parse('$baseUrl/letter-templates'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'body': body,
        'placeholders': placeholders,
      }),
    );

    if (response.statusCode == 201) {
      return LetterTemplate.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create letter template');
    }
  }

  Future<LetterTemplate> updateTemplate({
    required String id,
    required String title,
    required String body,
    required List<String> placeholders,
  }) async {
    final token = await ApiConfig.token;
    final response = await http.patch(
      Uri.parse('$baseUrl/letter-templates/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'body': body,
        'placeholders': placeholders,
      }),
    );

    if (response.statusCode == 200) {
      return LetterTemplate.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update letter template');
    }
  }

  Future<void> deleteTemplate(String id) async {
    final token = await ApiConfig.token;
    final response = await http.delete(
      Uri.parse('$baseUrl/letter-templates/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete letter template');
    }
  }
}
