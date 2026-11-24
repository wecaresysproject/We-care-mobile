import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_metric_model.dart';

part 'doctor_performance_stats_model.g.dart';

/// Profile views, shares and search appearances —
/// `GET /DoctorHome/performance-stats`.
@JsonSerializable(createToJson: false)
class DoctorPerformanceStatsModel {
  DoctorPerformanceStatsModel({
    required this.views,
    required this.shares,
    required this.appearances,
  });

  final DoctorPerformanceMetricModel views;
  final DoctorPerformanceMetricModel shares;
  final DoctorPerformanceMetricModel appearances;

  factory DoctorPerformanceStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorPerformanceStatsModelFromJson(json);
}
