import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/letter.dart';
import '../services/letter_service.dart';

final letterServiceProvider = Provider((ref) => LetterService());

// Provider for student's own letters
final studentLettersProvider = FutureProvider<List<Letter>>((ref) async {
  final service = ref.watch(letterServiceProvider);
  return service.getStudentLetters();
});

// Provider for staff created letters
final staffCreatedLettersProvider = FutureProvider<List<Letter>>((ref) async {
  final service = ref.watch(letterServiceProvider);
  return service.getStaffCreatedLetters();
});

// Provider for individual letter with template applied
final letterDetailProvider = FutureProvider.family<Letter, String>((ref, letterId) async {
  final service = ref.watch(letterServiceProvider);
  final letter = await service.getLetter(letterId);
  
  // Apply template variables to the letter content if templateVariables exist
  if (letter.templateVariables != null && letter.templateVariables!.isNotEmpty) {
    final processedContent = service.applyTemplate(letter.content, letter.templateVariables!);
    return letter.copyWith(content: processedContent);
  }
  
  return letter;
});
