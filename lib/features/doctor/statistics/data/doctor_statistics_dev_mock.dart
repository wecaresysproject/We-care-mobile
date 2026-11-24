import 'package:we_care/features/doctor/statistics/data/models/doctor_statistics_model.dart';

// TODO(statistics): delete this file, its use in DoctorStatisticsRepo and the
// line in main_development.dart once the backend ships
// `GET /DoctorHome/statistics` (docs/doctor_app_ui_updates_backend.md,
// section 3).

/// TEMPORARY sample "إحصائيات" while the endpoint doesn't exist (it answers
/// 404). Turned on from `main_development.dart` only, and used only when the
/// real request answers 404. The numbers shift a little per month, so
/// picking another month visibly changes them.
abstract final class DoctorStatisticsDevMock {
  static bool enabled = false;

  static DoctorStatisticsModel build({required int month, required int year}) {
    // 0.70 … 1.25, the same for the same month every time.
    final factor = 0.7 + ((month * 7 + year) % 12) * 0.05;
    int scaled(num value) => (value * factor).round();
    final paid = scaled(1248);
    final followUps = scaled(486);
    final days = (22 * factor).clamp(1, 28).round();
    final hours = scaled(36);
    return DoctorStatisticsModel(
      consultationsValue: paid * 200,
      currency: 'EGP',
      totalBookings: scaled(1562),
      paidConsultations: paid,
      followUps: followUps,
      followUpRatio: (followUps / paid * 1000).round() / 10,
      repeatPatientsWithoutFollowUp: scaled(126),
      repeatPatientRatio: 8.2,
      consultationDays: days,
      consultationHours: hours,
      averageConsultationMinutes: 18,
      unexaminedWaitingPatients: scaled(152),
    );
  }
}
