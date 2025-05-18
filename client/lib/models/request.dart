import 'package:freezed_annotation/freezed_annotation.dart';

part 'request.freezed.dart';
part 'request.g.dart';

enum RequestType {
  @JsonValue('letter')
  letter,
  @JsonValue('transcript')
  transcript,
  @JsonValue('other')
  other,
}

enum RequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('completed')
  completed,
}

@freezed
class Request with _$Request {
  const factory Request({
    required String id,
    required RequestType type,
    required RequestStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? notes,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
}
