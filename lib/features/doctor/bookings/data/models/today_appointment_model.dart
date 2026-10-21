import 'package:we_care/features/doctor/bookings/data/models/appointment_time_status.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

class TodayAppointmentModel {
  TodayAppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientPhotoUrl,
    required this.type,
    required this.startsAt,
    this.dataAccessExpiresAt,
  });

  /// One `todayAppointments[]` item — also the `data` of accept.
  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) {
    return TodayAppointmentModel(
      id: json['bookingId']?.toString() ?? '',
      patientName: json['patientName'] as String? ?? '',
      patientPhotoUrl: bookingsImageUrl(json['patientImageUrl']),
      type: AppointmentType.fromApi(json['type'] as String?),
      startsAt: parseBookingsInstant(json['startsAt']) ?? DateTime.now(),
      dataAccessExpiresAt: parseBookingsInstant(json['dataAccessExpiresAt']),
    );
  }

  /// `bookingId`.
  final String id;
  final String patientName;
  final String? patientPhotoUrl;
  final AppointmentType type;
  final DateTime startsAt;

  /// End of the patient's data-access window — null when the patient
  /// granted no access (or the backend doesn't send it yet).
  final DateTime? dataAccessExpiresAt;

  /// The doctor can still open the patient's medical file.
  bool hasOpenDataAccess(DateTime now) =>
      dataAccessExpiresAt != null && now.isBefore(dataAccessExpiresAt!);

  /// "09:00 ص".
  String get bookingTimeLabel => bookingClockLabel(startsAt);

  /// Whole minutes until [startsAt] — negative once it has passed.
  int _minutesUntilStart(DateTime now) =>
      startsAt.difference(now).inSeconds ~/ 60;

  /// "حان الموعد" during the minute around [startsAt], "متبقي" before it and
  /// "متأخر" after it.
  AppointmentTimeStatus timeStatus(DateTime now) {
    final minutes = _minutesUntilStart(now);
    if (minutes > 0) return AppointmentTimeStatus.remaining;
    if (minutes < 0) return AppointmentTimeStatus.late_;
    return AppointmentTimeStatus.due;
  }

  /// Minutes remaining/late — null when the appointment is due.
  int? statusMinutes(DateTime now) {
    final minutes = _minutesUntilStart(now).abs();
    return minutes == 0 ? null : minutes;
  }
}
