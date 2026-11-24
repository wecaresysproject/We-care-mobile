import 'package:json_annotation/json_annotation.dart';

part 'doctor_performance_metric_model.g.dart';

/// One performance counter over two rolling windows ending now.
@JsonSerializable(createToJson: false)
class DoctorPerformanceMetricModel {
  DoctorPerformanceMetricModel({
    required this.last30Days,
    required this.last12Months,
  });

  /// "في الشهر" — the last 30 days.
  @JsonKey(defaultValue: 0)
  final int last30Days;

  /// "في السنة" — the last 12 months.
  @JsonKey(defaultValue: 0)
  final int last12Months;

  factory DoctorPerformanceMetricModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorPerformanceMetricModelFromJson(json);
}
