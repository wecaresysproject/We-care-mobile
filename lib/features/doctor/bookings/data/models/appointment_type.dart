/// "كشف" (examination) vs "استشارة" (consultation) appointment type badge.
enum AppointmentType {
  examination,
  consultation;

  /// API `type` — `onlineExamination` | `freeFollowUpConsultation`. Any
  /// unknown value is treated as an examination.
  static AppointmentType fromApi(String? value) =>
      value == 'freeFollowUpConsultation'
          ? AppointmentType.consultation
          : AppointmentType.examination;
}

/// "09:00 ص" — 12-hour clock with a leading zero, as the bookings rows show.
String bookingClockLabel(DateTime time) {
  final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final period = time.hour < 12 ? 'ص' : 'م';
  return "${hour12.toString().padLeft(2, '0')}:"
      "${time.minute.toString().padLeft(2, '0')} $period";
}

/// `startsAt` / `requestedAt` arrive as ISO 8601 with an offset — converted
/// to device time so the minute counters run from the same instant.
DateTime? parseBookingsInstant(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;

/// `null` and blank image URLs both mean "no photo".
String? bookingsImageUrl(Object? value) =>
    value is String && value.trim().isNotEmpty ? value : null;
