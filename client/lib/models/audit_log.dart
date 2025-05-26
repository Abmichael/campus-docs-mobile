import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String action,
    required String user,
    required String timestamp,
    Map<String, dynamic>? details,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
