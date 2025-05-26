import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_settings.freezed.dart';
part 'system_settings.g.dart';

@freezed
class SystemSettings with _$SystemSettings {
  const factory SystemSettings({
    required String systemName,
    required String emailFrom,
    required String smtpServer,
    required String smtpPort,
    required String smtpUsername,
    required String smtpPassword,
  }) = _SystemSettings;

  factory SystemSettings.fromJson(Map<String, dynamic> json) =>
      _$SystemSettingsFromJson(json);
}
