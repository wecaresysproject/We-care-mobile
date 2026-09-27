import 'package:json_annotation/json_annotation.dart';

part 'doctor_performance_metric_model.g.dart';

@JsonSerializable()
class DoctorPerformanceMetricModel {
  DoctorPerformanceMetricModel({
    required this.monthlyCount,
    required this.yearlyCount,
  });

  final int monthlyCount;
  final int yearlyCount;

  factory DoctorPerformanceMetricModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorPerformanceMetricModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorPerformanceMetricModelToJson(this);
}
