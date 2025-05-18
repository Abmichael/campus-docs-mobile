import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter_template.freezed.dart';
part 'letter_template.g.dart';

@freezed
class LetterTemplate with _$LetterTemplate {
  const factory LetterTemplate({
    required String id,
    required String title,
    required String body,
    required List<String> placeholders,
  }) = _LetterTemplate;

  factory LetterTemplate.fromJson(Map<String, dynamic> json) =>
      _$LetterTemplateFromJson(json);
}
