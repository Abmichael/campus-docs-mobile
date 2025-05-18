import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/letter_template.dart';
import '../services/letter_template_service.dart';

final letterTemplateServiceProvider =
    Provider((ref) => LetterTemplateService());

final letterTemplatesProvider =
    FutureProvider<List<LetterTemplate>>((ref) async {
  final service = ref.watch(letterTemplateServiceProvider);
  return service.getTemplates();
});
