import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday_schedule_model.dart';

part 'booking_settings_request_body_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingSettingsRequestBodyModel {
  final int maxDailyBookings;
  final int intervalMinutes;
  final List<WeekdayScheduleModel> weeklySchedule;

  BookingSettingsRequestBodyModel({
    required this.maxDailyBookings,
    required this.intervalMinutes,
    required this.weeklySchedule,
  });

  Map<String, dynamic> toJson() =>
      _$BookingSettingsRequestBodyModelToJson(this);
}
