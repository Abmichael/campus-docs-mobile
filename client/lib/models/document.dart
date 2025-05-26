import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';
part 'document.g.dart';

@freezed
class Document with _$Document {
  const factory Document({
    required String id,
    required String requestId,
    required String userId,
    required String createdBy,
    required String createdAt,
    required String content,
    String? signedBy,
    String? signedAt,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}
