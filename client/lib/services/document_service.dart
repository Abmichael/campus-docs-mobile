import 'dart:convert';
import '../models/document.dart';
import 'http_service.dart';

class DocumentService {
  final HttpService _httpService = HttpService();

  Future<List<Document>> getStudentDocuments() async {
    final response = await _httpService.get('/letters');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  Future<Document> getDocument(String documentId) async {
    final response = await _httpService.get('/letters/$documentId');

    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load document');
    }
  }
}
