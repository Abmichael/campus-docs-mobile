// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogImpl _$$AuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogImpl(
      id: json['id'] as String,
      action: json['action'] as String,
      user: json['user'] as String,
      timestamp: json['timestamp'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AuditLogImplToJson(_$AuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'user': instance.user,
      'timestamp': instance.timestamp,
      'details': instance.details,
    };
