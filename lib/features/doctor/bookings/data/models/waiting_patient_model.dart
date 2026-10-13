import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

class WaitingPatientModel {
  WaitingPatientModel({
    required this.id,
    required this.patientName,
    required this.patientPhotoUrl,
    required this.type,
    required this.requestedAt,
  });

  /// One `waitingPatients[]` item.
  factory WaitingPatientModel.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'] as Map<String, dynamic>? ?? const {};
    return WaitingPatientModel(
      id: json['bookingId']?.toString() ?? '',
      patientName: patient['name'] as String? ?? '',
      patientPhotoUrl: bookingsImageUrl(patient['profileImage']),
      type: AppointmentType.fromApi(json['type'] as String?),
      requestedAt: parseBookingsInstant(json['requestedAt']) ?? DateTime.now(),
    );
  }

  /// `bookingId` — sent to accept / reject.
  final String id;
  final String patientName;
  final String? patientPhotoUrl;
  final AppointmentType type;

  /// When the patient joined the waiting list.
  final DateTime requestedAt;

  /// "08:15 ص".
  String get joinRequestTimeLabel => bookingClockLabel(requestedAt);

  /// "منذ N دقيقة" — never negative if the device clock is behind.
  int waitingMinutes(DateTime now) {
    final minutes = now.difference(requestedAt).inMinutes;
    return minutes < 0 ? 0 : minutes;
  }
}
