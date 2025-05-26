// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentImpl _$$DocumentImplFromJson(Map<String, dynamic> json) =>
    _$DocumentImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      userId: json['userId'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      content: json['content'] as String,
      signedBy: json['signedBy'] as String?,
      signedAt: json['signedAt'] as String?,
    );

Map<String, dynamic> _$$DocumentImplToJson(_$DocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'userId': instance.userId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'content': instance.content,
      'signedBy': instance.signedBy,
      'signedAt': instance.signedAt,
    };
