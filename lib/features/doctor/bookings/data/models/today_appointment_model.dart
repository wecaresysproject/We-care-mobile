import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_time_status.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

part 'today_appointment_model.g.dart';

@JsonSerializable()
class TodayAppointmentModel {
  TodayAppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientPhotoUrl,
    required this.bookingTimeLabel,
    required this.type,
    required this.timeStatus,
    required this.statusMinutes,
  });

  final String id;
  final String patientName;
  final String? patientPhotoUrl;
  final String bookingTimeLabel;
  final AppointmentType type;
  final AppointmentTimeStatus timeStatus;

  /// Minutes remaining/late — null when [timeStatus] is [AppointmentTimeStatus.due].
  final int? statusMinutes;

  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$TodayAppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodayAppointmentModelToJson(this);
}
