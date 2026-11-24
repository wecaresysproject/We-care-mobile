/// One month of "إحصائيات" (`GET /DoctorHome/statistics`).
class DoctorStatisticsModel {
  const DoctorStatisticsModel({
    required this.consultationsValue,
    required this.currency,
    required this.totalBookings,
    required this.paidConsultations,
    required this.followUps,
    required this.followUpRatio,
    required this.repeatPatientsWithoutFollowUp,
    required this.repeatPatientRatio,
    required this.consultationDays,
    required this.consultationHours,
    required this.averageConsultationMinutes,
    required this.unexaminedWaitingPatients,
  });

  /// قيمة الكشوفات.
  final num consultationsValue;

  /// "EGP" unless the API says otherwise.
  final String currency;

  /// عدد الحجوزات الإجمالية.
  final int totalBookings;

  /// عدد الكشوفات المدفوعة.
  final int paidConsultations;

  /// عدد المتابعات.
  final int followUps;

  /// نسبة المتابعات للكشوفات, as a percentage (31.1 = 31.1%).
  final num followUpRatio;

  /// عدد المرضى المكررين بدون المتابعات.
  final int repeatPatientsWithoutFollowUp;

  /// نسبة المرضى المكررين لإجمالي المرضى, as a percentage.
  final num repeatPatientRatio;

  /// عدد أيام الكشوفات.
  final int consultationDays;

  /// عدد ساعات الكشوفات — may have a fraction (12.5).
  final num consultationHours;

  /// متوسط مدة الكشف, in minutes.
  final num averageConsultationMinutes;

  /// عدد مرضى الانتظار الذين لم يتم الكشف عليهم.
  final int unexaminedWaitingPatients;

  factory DoctorStatisticsModel.fromJson(Map<String, dynamic> json) {
    num n(String key) => json[key] is num ? json[key] as num : 0;
    int i(String key) => n(key).toInt();
    final currency = json['currency']?.toString().trim() ?? '';
    return DoctorStatisticsModel(
      consultationsValue: n('consultationsValue'),
      currency: currency.isEmpty ? 'EGP' : currency,
      totalBookings: i('totalBookings'),
      paidConsultations: i('paidConsultations'),
      followUps: i('followUps'),
      followUpRatio: n('followUpRatio'),
      repeatPatientsWithoutFollowUp: i('repeatPatientsWithoutFollowUp'),
      repeatPatientRatio: n('repeatPatientRatio'),
      consultationDays: i('consultationDays'),
      consultationHours: n('consultationHours'),
      averageConsultationMinutes: n('averageConsultationMinutes'),
      unexaminedWaitingPatients: i('unexaminedWaitingPatients'),
    );
  }
}
