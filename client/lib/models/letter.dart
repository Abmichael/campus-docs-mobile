import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter.freezed.dart';
part 'letter.g.dart';

@freezed
class Letter with _$Letter {
  const factory Letter({
    required String id,
    required String requestId,
    required String userId,
    required String createdBy,
    required String createdAt,
    required String content,
    String? signedBy,
    String? signedAt,
    String? templateId,
    Map<String, String>? templateVariables,
  }) = _Letter;

  factory Letter.fromJson(Map<String, dynamic> json) =>
      _$LetterFromJson(json);
}
