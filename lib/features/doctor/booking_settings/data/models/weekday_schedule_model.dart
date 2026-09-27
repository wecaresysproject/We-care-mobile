import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/time_range_model.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday.dart';

part 'weekday_schedule_model.g.dart';

/// One weekday row in the weekly booking timetable: whether the doctor
/// accepts bookings that day, and the time ranges within it.
@JsonSerializable(explicitToJson: true)
class WeekdayScheduleModel {
  final Weekday day;
  final bool isEnabled;
  final List<TimeRangeModel> timeRanges;

  WeekdayScheduleModel({
    required this.day,
    required this.isEnabled,
    required this.timeRanges,
  });

  factory WeekdayScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$WeekdayScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeekdayScheduleModelToJson(this);

  WeekdayScheduleModel copyWith({
    bool? isEnabled,
    List<TimeRangeModel>? timeRanges,
  }) {
    return WeekdayScheduleModel(
      day: day,
      isEnabled: isEnabled ?? this.isEnabled,
      timeRanges: timeRanges ?? this.timeRanges,
    );
  }
}
