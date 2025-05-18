// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LetterTemplateImpl _$$LetterTemplateImplFromJson(Map<String, dynamic> json) =>
    _$LetterTemplateImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      placeholders: (json['placeholders'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$LetterTemplateImplToJson(
        _$LetterTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'placeholders': instance.placeholders,
    };
