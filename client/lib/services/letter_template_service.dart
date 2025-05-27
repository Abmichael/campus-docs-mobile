import 'dart:convert';
import '../models/letter_template.dart';
import 'http_service.dart';

class LetterTemplateService {
  final HttpService _httpService = HttpService();

  Future<List<LetterTemplate>> fetchTemplates() async {
    final response = await _httpService.get('/letter-templates');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LetterTemplate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load letter templates');
    }
  }

  Future<List<LetterTemplate>> getTemplates() async {
    final response = await _httpService.get('/letter-templates');

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
    final response = await _httpService.post('/letter-templates', body: {
      'title': title,
      'body': body,
      'placeholders': placeholders,
    });

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
    final response = await _httpService.patch('/letter-templates/$id', body: {
      'title': title,
      'body': body,
      'placeholders': placeholders,
    });

    if (response.statusCode == 200) {
      return LetterTemplate.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update letter template');
    }
  }

  Future<void> deleteTemplate(String id) async {
    final response = await _httpService.delete('/letter-templates/$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete letter template');
    }
  }
}
