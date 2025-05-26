// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Letter _$LetterFromJson(Map<String, dynamic> json) {
  return _Letter.fromJson(json);
}

/// @nodoc
mixin _$Letter {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get signedBy => throw _privateConstructorUsedError;
  String? get signedAt => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  Map<String, String>? get templateVariables =>
      throw _privateConstructorUsedError;

  /// Serializes this Letter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Letter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LetterCopyWith<Letter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LetterCopyWith<$Res> {
  factory $LetterCopyWith(Letter value, $Res Function(Letter) then) =
      _$LetterCopyWithImpl<$Res, Letter>;
  @useResult
  $Res call(
      {String id,
      String requestId,
      String userId,
      String createdBy,
      String createdAt,
      String content,
      String? signedBy,
      String? signedAt,
      String? templateId,
      Map<String, String>? templateVariables});
}

/// @nodoc
class _$LetterCopyWithImpl<$Res, $Val extends Letter>
    implements $LetterCopyWith<$Res> {
  _$LetterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Letter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? userId = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? content = null,
    Object? signedBy = freezed,
    Object? signedAt = freezed,
    Object? templateId = freezed,
    Object? templateVariables = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      signedBy: freezed == signedBy
          ? _value.signedBy
          : signedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      signedAt: freezed == signedAt
          ? _value.signedAt
          : signedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateVariables: freezed == templateVariables
          ? _value.templateVariables
          : templateVariables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LetterImplCopyWith<$Res> implements $LetterCopyWith<$Res> {
  factory _$$LetterImplCopyWith(
          _$LetterImpl value, $Res Function(_$LetterImpl) then) =
      __$$LetterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestId,
      String userId,
      String createdBy,
      String createdAt,
      String content,
      String? signedBy,
      String? signedAt,
      String? templateId,
      Map<String, String>? templateVariables});
}

/// @nodoc
class __$$LetterImplCopyWithImpl<$Res>
    extends _$LetterCopyWithImpl<$Res, _$LetterImpl>
    implements _$$LetterImplCopyWith<$Res> {
  __$$LetterImplCopyWithImpl(
      _$LetterImpl _value, $Res Function(_$LetterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Letter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? userId = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? content = null,
    Object? signedBy = freezed,
    Object? signedAt = freezed,
    Object? templateId = freezed,
    Object? templateVariables = freezed,
  }) {
    return _then(_$LetterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      signedBy: freezed == signedBy
          ? _value.signedBy
          : signedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      signedAt: freezed == signedAt
          ? _value.signedAt
          : signedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateVariables: freezed == templateVariables
          ? _value._templateVariables
          : templateVariables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LetterImpl implements _Letter {
  const _$LetterImpl(
      {required this.id,
      required this.requestId,
      required this.userId,
      required this.createdBy,
      required this.createdAt,
      required this.content,
      this.signedBy,
      this.signedAt,
      this.templateId,
      final Map<String, String>? templateVariables})
      : _templateVariables = templateVariables;

  factory _$LetterImpl.fromJson(Map<String, dynamic> json) =>
      _$$LetterImplFromJson(json);

  @override
  final String id;
  @override
  final String requestId;
  @override
  final String userId;
  @override
  final String createdBy;
  @override
  final String createdAt;
  @override
  final String content;
  @override
  final String? signedBy;
  @override
  final String? signedAt;
  @override
  final String? templateId;
  final Map<String, String>? _templateVariables;
  @override
  Map<String, String>? get templateVariables {
    final value = _templateVariables;
    if (value == null) return null;
    if (_templateVariables is EqualUnmodifiableMapView)
      return _templateVariables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Letter(id: $id, requestId: $requestId, userId: $userId, createdBy: $createdBy, createdAt: $createdAt, content: $content, signedBy: $signedBy, signedAt: $signedAt, templateId: $templateId, templateVariables: $templateVariables)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LetterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.signedBy, signedBy) ||
                other.signedBy == signedBy) &&
            (identical(other.signedAt, signedAt) ||
                other.signedAt == signedAt) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            const DeepCollectionEquality()
                .equals(other._templateVariables, _templateVariables));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      userId,
      createdBy,
      createdAt,
      content,
      signedBy,
      signedAt,
      templateId,
      const DeepCollectionEquality().hash(_templateVariables));

  /// Create a copy of Letter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LetterImplCopyWith<_$LetterImpl> get copyWith =>
      __$$LetterImplCopyWithImpl<_$LetterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LetterImplToJson(
      this,
    );
  }
}

abstract class _Letter implements Letter {
  const factory _Letter(
      {required final String id,
      required final String requestId,
      required final String userId,
      required final String createdBy,
      required final String createdAt,
      required final String content,
      final String? signedBy,
      final String? signedAt,
      final String? templateId,
      final Map<String, String>? templateVariables}) = _$LetterImpl;

  factory _Letter.fromJson(Map<String, dynamic> json) = _$LetterImpl.fromJson;

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get userId;
  @override
  String get createdBy;
  @override
  String get createdAt;
  @override
  String get content;
  @override
  String? get signedBy;
  @override
  String? get signedAt;
  @override
  String? get templateId;
  @override
  Map<String, String>? get templateVariables;

  /// Create a copy of Letter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LetterImplCopyWith<_$LetterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
