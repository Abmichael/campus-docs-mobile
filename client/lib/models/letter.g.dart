// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LetterImpl _$$LetterImplFromJson(Map<String, dynamic> json) => _$LetterImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      userId: json['userId'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      content: json['content'] as String,
      signedBy: json['signedBy'] as String?,
      signedAt: json['signedAt'] as String?,
      templateId: json['templateId'] as String?,
      templateVariables:
          (json['templateVariables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$LetterImplToJson(_$LetterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'userId': instance.userId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'content': instance.content,
      'signedBy': instance.signedBy,
      'signedAt': instance.signedAt,
      'templateId': instance.templateId,
      'templateVariables': instance.templateVariables,
    };
