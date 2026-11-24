import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

/// One of today's appointments whose session is over — a row in
/// "الكشوفات المنتهية".
class CompletedAppointmentModel {
  CompletedAppointmentModel({
    required this.id,
    required this.patientName,
    required this.type,
    required this.startsAt,
    this.completedAt,
  });

  /// One `completedAppointments[]` item — same fields as an appointment,
  /// plus `completedAt`.
  factory CompletedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return CompletedAppointmentModel(
      id: json['bookingId']?.toString() ?? '',
      patientName: json['patientName'] as String? ?? '',
      type: AppointmentType.fromApi(json['type'] as String?),
      startsAt: parseBookingsInstant(json['startsAt']) ?? DateTime.now(),
      completedAt: parseBookingsInstant(json['completedAt']),
    );
  }

  /// `bookingId`.
  final String id;
  final String patientName;
  final AppointmentType type;
  final DateTime startsAt;

  /// When the doctor ended the session.
  final DateTime? completedAt;

  /// "09:00 ص" — the appointment time.
  String get bookingTimeLabel => bookingClockLabel(startsAt);
}
