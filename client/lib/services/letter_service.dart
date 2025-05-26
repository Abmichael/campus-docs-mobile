import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/letter.dart';
import '../config/api_config.dart';

class LetterService {
  Future<String> get baseUrl => ApiConfig.baseUrl;
  Future<List<Letter>> getStudentLetters() async {
    final token = await ApiConfig.token;
    final url = await baseUrl;
    final response = await http.get(
      Uri.parse('$url/letters/my-documents'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Letter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load letters');
    }
  }
  Future<List<Letter>> getStaffCreatedLetters() async {
    final token = await ApiConfig.token;
    final url = await baseUrl;
    final response = await http.get(
      Uri.parse('$url/letters/my-created'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Letter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load created letters');
    }
  }
  Future<Letter> getLetter(String letterId) async {
    final token = await ApiConfig.token;
    final url = await baseUrl;
    final response = await http.get(
      Uri.parse('$url/letters/$letterId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Letter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load letter');
    }
  }

  Future<Letter> createLetter({
    required String requestId,
    required String content,
    String? templateId,
    Map<String, String>? templateVariables,  }) async {
    final token = await ApiConfig.token;
    final url = await baseUrl;
    final response = await http.post(
      Uri.parse('$url/letters'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'requestId': requestId,
        'content': content,
        if (templateId != null) 'templateId': templateId,
        if (templateVariables != null) 'templateVariables': templateVariables,
      }),
    );

    if (response.statusCode == 201) {
      return Letter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create letter');
    }
  }
  String applyTemplate(String templateBody, Map<String, String> variables) {
    String result = templateBody;
    variables.forEach((key, value) {
      // Support both [placeholder] and {{placeholder}} syntax
      result = result.replaceAll('[$key]', value);
      result = result.replaceAll('{{$key}}', value);
    });
    return result;
  }

  String getPlaceholdersFromTemplate(String templateBody) {
    // Extract placeholders from template body using regex
    final RegExp regex = RegExp(r'\[([^\]]+)\]');
    final matches = regex.allMatches(templateBody);
    return matches.map((match) => match.group(1)!).join(', ');
  }
}
