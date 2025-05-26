import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/document.dart';
import '../config/api_config.dart';

class DocumentService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<Document>> getStudentDocuments() async {
    final token = await ApiConfig.token;
    final response = await http.get(
      Uri.parse('$baseUrl/letters'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  Future<Document> getDocument(String documentId) async {
    final token = await ApiConfig.token;
    final response = await http.get(
      Uri.parse('$baseUrl/letters/$documentId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load document');
    }
  }
}
