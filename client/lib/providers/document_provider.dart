import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document.dart';
import '../services/document_service.dart';

final documentServiceProvider = Provider((ref) => DocumentService());

final studentDocumentsProvider = FutureProvider<List<Document>>((ref) async {
  final service = ref.watch(documentServiceProvider);
  return service.getStudentDocuments();
});

final documentDetailProvider = FutureProvider.family<Document, String>((ref, documentId) async {
  final service = ref.watch(documentServiceProvider);
  return service.getDocument(documentId);
});
