import 'package:json_annotation/json_annotation.dart';

part 'time_range_model.g.dart';

/// One booking time slot within a day, e.g. "10:00" – "13:00" (24h `HH:mm`).
@JsonSerializable()
class TimeRangeModel {
  final String startTime;
  final String endTime;

  TimeRangeModel({required this.startTime, required this.endTime});

  factory TimeRangeModel.fromJson(Map<String, dynamic> json) =>
      _$TimeRangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeRangeModelToJson(this);
}
