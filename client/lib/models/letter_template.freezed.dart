// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LetterTemplate _$LetterTemplateFromJson(Map<String, dynamic> json) {
  return _LetterTemplate.fromJson(json);
}

/// @nodoc
mixin _$LetterTemplate {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  List<String> get placeholders => throw _privateConstructorUsedError;

  /// Serializes this LetterTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LetterTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LetterTemplateCopyWith<LetterTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LetterTemplateCopyWith<$Res> {
  factory $LetterTemplateCopyWith(
          LetterTemplate value, $Res Function(LetterTemplate) then) =
      _$LetterTemplateCopyWithImpl<$Res, LetterTemplate>;
  @useResult
  $Res call({String id, String title, String body, List<String> placeholders});
}

/// @nodoc
class _$LetterTemplateCopyWithImpl<$Res, $Val extends LetterTemplate>
    implements $LetterTemplateCopyWith<$Res> {
  _$LetterTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LetterTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? placeholders = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      placeholders: null == placeholders
          ? _value.placeholders
          : placeholders // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LetterTemplateImplCopyWith<$Res>
    implements $LetterTemplateCopyWith<$Res> {
  factory _$$LetterTemplateImplCopyWith(_$LetterTemplateImpl value,
          $Res Function(_$LetterTemplateImpl) then) =
      __$$LetterTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String body, List<String> placeholders});
}

/// @nodoc
class __$$LetterTemplateImplCopyWithImpl<$Res>
    extends _$LetterTemplateCopyWithImpl<$Res, _$LetterTemplateImpl>
    implements _$$LetterTemplateImplCopyWith<$Res> {
  __$$LetterTemplateImplCopyWithImpl(
      _$LetterTemplateImpl _value, $Res Function(_$LetterTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LetterTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? placeholders = null,
  }) {
    return _then(_$LetterTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      placeholders: null == placeholders
          ? _value._placeholders
          : placeholders // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LetterTemplateImpl implements _LetterTemplate {
  const _$LetterTemplateImpl(
      {required this.id,
      required this.title,
      required this.body,
      required final List<String> placeholders})
      : _placeholders = placeholders;

  factory _$LetterTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LetterTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  final List<String> _placeholders;
  @override
  List<String> get placeholders {
    if (_placeholders is EqualUnmodifiableListView) return _placeholders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_placeholders);
  }

  @override
  String toString() {
    return 'LetterTemplate(id: $id, title: $title, body: $body, placeholders: $placeholders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LetterTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality()
                .equals(other._placeholders, _placeholders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, body,
      const DeepCollectionEquality().hash(_placeholders));

  /// Create a copy of LetterTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LetterTemplateImplCopyWith<_$LetterTemplateImpl> get copyWith =>
      __$$LetterTemplateImplCopyWithImpl<_$LetterTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LetterTemplateImplToJson(
      this,
    );
  }
}

abstract class _LetterTemplate implements LetterTemplate {
  const factory _LetterTemplate(
      {required final String id,
      required final String title,
      required final String body,
      required final List<String> placeholders}) = _$LetterTemplateImpl;

  factory _LetterTemplate.fromJson(Map<String, dynamic> json) =
      _$LetterTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  List<String> get placeholders;

  /// Create a copy of LetterTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LetterTemplateImplCopyWith<_$LetterTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
