// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalUsers: (json['totalUsers'] as num).toInt(),
      activeRequests: (json['activeRequests'] as num).toInt(),
      pendingApprovals: (json['pendingApprovals'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'activeRequests': instance.activeRequests,
      'pendingApprovals': instance.pendingApprovals,
    };
