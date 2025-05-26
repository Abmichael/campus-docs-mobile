// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestImpl _$$RequestImplFromJson(Map<String, dynamic> json) =>
    _$RequestImpl(
      id: json['id'] as String,
      type: $enumDecode(_$RequestTypeEnumMap, json['type']),
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userStudentId: json['userStudentId'] as String?,
    );

Map<String, dynamic> _$$RequestImplToJson(_$RequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$RequestTypeEnumMap[instance.type]!,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notes': instance.notes,
      'userId': instance.userId,
      'userName': instance.userName,
      'userStudentId': instance.userStudentId,
    };

const _$RequestTypeEnumMap = {
  RequestType.letter: 'letter',
  RequestType.transcript: 'transcript',
  RequestType.other: 'other',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
  RequestStatus.completed: 'completed',
};
