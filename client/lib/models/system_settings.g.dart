// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemSettingsImpl _$$SystemSettingsImplFromJson(Map<String, dynamic> json) =>
    _$SystemSettingsImpl(
      systemName: json['systemName'] as String,
      emailFrom: json['emailFrom'] as String,
      smtpServer: json['smtpServer'] as String,
      smtpPort: json['smtpPort'] as String,
      smtpUsername: json['smtpUsername'] as String,
      smtpPassword: json['smtpPassword'] as String,
    );

Map<String, dynamic> _$$SystemSettingsImplToJson(
        _$SystemSettingsImpl instance) =>
    <String, dynamic>{
      'systemName': instance.systemName,
      'emailFrom': instance.emailFrom,
      'smtpServer': instance.smtpServer,
      'smtpPort': instance.smtpPort,
      'smtpUsername': instance.smtpUsername,
      'smtpPassword': instance.smtpPassword,
    };
