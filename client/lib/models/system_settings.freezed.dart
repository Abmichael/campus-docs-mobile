// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SystemSettings _$SystemSettingsFromJson(Map<String, dynamic> json) {
  return _SystemSettings.fromJson(json);
}

/// @nodoc
mixin _$SystemSettings {
  String get systemName => throw _privateConstructorUsedError;
  String get emailFrom => throw _privateConstructorUsedError;
  String get smtpServer => throw _privateConstructorUsedError;
  String get smtpPort => throw _privateConstructorUsedError;
  String get smtpUsername => throw _privateConstructorUsedError;
  String get smtpPassword => throw _privateConstructorUsedError;

  /// Serializes this SystemSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemSettingsCopyWith<SystemSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemSettingsCopyWith<$Res> {
  factory $SystemSettingsCopyWith(
          SystemSettings value, $Res Function(SystemSettings) then) =
      _$SystemSettingsCopyWithImpl<$Res, SystemSettings>;
  @useResult
  $Res call(
      {String systemName,
      String emailFrom,
      String smtpServer,
      String smtpPort,
      String smtpUsername,
      String smtpPassword});
}

/// @nodoc
class _$SystemSettingsCopyWithImpl<$Res, $Val extends SystemSettings>
    implements $SystemSettingsCopyWith<$Res> {
  _$SystemSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = null,
    Object? emailFrom = null,
    Object? smtpServer = null,
    Object? smtpPort = null,
    Object? smtpUsername = null,
    Object? smtpPassword = null,
  }) {
    return _then(_value.copyWith(
      systemName: null == systemName
          ? _value.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      emailFrom: null == emailFrom
          ? _value.emailFrom
          : emailFrom // ignore: cast_nullable_to_non_nullable
              as String,
      smtpServer: null == smtpServer
          ? _value.smtpServer
          : smtpServer // ignore: cast_nullable_to_non_nullable
              as String,
      smtpPort: null == smtpPort
          ? _value.smtpPort
          : smtpPort // ignore: cast_nullable_to_non_nullable
              as String,
      smtpUsername: null == smtpUsername
          ? _value.smtpUsername
          : smtpUsername // ignore: cast_nullable_to_non_nullable
              as String,
      smtpPassword: null == smtpPassword
          ? _value.smtpPassword
          : smtpPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemSettingsImplCopyWith<$Res>
    implements $SystemSettingsCopyWith<$Res> {
  factory _$$SystemSettingsImplCopyWith(_$SystemSettingsImpl value,
          $Res Function(_$SystemSettingsImpl) then) =
      __$$SystemSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String systemName,
      String emailFrom,
      String smtpServer,
      String smtpPort,
      String smtpUsername,
      String smtpPassword});
}

/// @nodoc
class __$$SystemSettingsImplCopyWithImpl<$Res>
    extends _$SystemSettingsCopyWithImpl<$Res, _$SystemSettingsImpl>
    implements _$$SystemSettingsImplCopyWith<$Res> {
  __$$SystemSettingsImplCopyWithImpl(
      _$SystemSettingsImpl _value, $Res Function(_$SystemSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SystemSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = null,
    Object? emailFrom = null,
    Object? smtpServer = null,
    Object? smtpPort = null,
    Object? smtpUsername = null,
    Object? smtpPassword = null,
  }) {
    return _then(_$SystemSettingsImpl(
      systemName: null == systemName
          ? _value.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      emailFrom: null == emailFrom
          ? _value.emailFrom
          : emailFrom // ignore: cast_nullable_to_non_nullable
              as String,
      smtpServer: null == smtpServer
          ? _value.smtpServer
          : smtpServer // ignore: cast_nullable_to_non_nullable
              as String,
      smtpPort: null == smtpPort
          ? _value.smtpPort
          : smtpPort // ignore: cast_nullable_to_non_nullable
              as String,
      smtpUsername: null == smtpUsername
          ? _value.smtpUsername
          : smtpUsername // ignore: cast_nullable_to_non_nullable
              as String,
      smtpPassword: null == smtpPassword
          ? _value.smtpPassword
          : smtpPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemSettingsImpl implements _SystemSettings {
  const _$SystemSettingsImpl(
      {required this.systemName,
      required this.emailFrom,
      required this.smtpServer,
      required this.smtpPort,
      required this.smtpUsername,
      required this.smtpPassword});

  factory _$SystemSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemSettingsImplFromJson(json);

  @override
  final String systemName;
  @override
  final String emailFrom;
  @override
  final String smtpServer;
  @override
  final String smtpPort;
  @override
  final String smtpUsername;
  @override
  final String smtpPassword;

  @override
  String toString() {
    return 'SystemSettings(systemName: $systemName, emailFrom: $emailFrom, smtpServer: $smtpServer, smtpPort: $smtpPort, smtpUsername: $smtpUsername, smtpPassword: $smtpPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemSettingsImpl &&
            (identical(other.systemName, systemName) ||
                other.systemName == systemName) &&
            (identical(other.emailFrom, emailFrom) ||
                other.emailFrom == emailFrom) &&
            (identical(other.smtpServer, smtpServer) ||
                other.smtpServer == smtpServer) &&
            (identical(other.smtpPort, smtpPort) ||
                other.smtpPort == smtpPort) &&
            (identical(other.smtpUsername, smtpUsername) ||
                other.smtpUsername == smtpUsername) &&
            (identical(other.smtpPassword, smtpPassword) ||
                other.smtpPassword == smtpPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, systemName, emailFrom,
      smtpServer, smtpPort, smtpUsername, smtpPassword);

  /// Create a copy of SystemSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemSettingsImplCopyWith<_$SystemSettingsImpl> get copyWith =>
      __$$SystemSettingsImplCopyWithImpl<_$SystemSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemSettingsImplToJson(
      this,
    );
  }
}

abstract class _SystemSettings implements SystemSettings {
  const factory _SystemSettings(
      {required final String systemName,
      required final String emailFrom,
      required final String smtpServer,
      required final String smtpPort,
      required final String smtpUsername,
      required final String smtpPassword}) = _$SystemSettingsImpl;

  factory _SystemSettings.fromJson(Map<String, dynamic> json) =
      _$SystemSettingsImpl.fromJson;

  @override
  String get systemName;
  @override
  String get emailFrom;
  @override
  String get smtpServer;
  @override
  String get smtpPort;
  @override
  String get smtpUsername;
  @override
  String get smtpPassword;

  /// Create a copy of SystemSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemSettingsImplCopyWith<_$SystemSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
