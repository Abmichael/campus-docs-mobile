import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats.g.dart';

@JsonSerializable()
class DashboardStats {
  final int totalUsers;
  final int activeRequests;
  final int pendingApprovals;

  DashboardStats({
    required this.totalUsers,
    required this.activeRequests,
    required this.pendingApprovals,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}
