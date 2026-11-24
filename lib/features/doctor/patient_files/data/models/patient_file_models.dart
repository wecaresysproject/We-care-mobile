import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

/// "حالة الكشف" of an open patient file's booking.
enum PatientFileBookingStatus {
  /// The examination hasn't happened yet — "مجدول".
  scheduled,

  /// The examination is over — "منتهي".
  completed;

  /// API `status` — `scheduled` | `completed`. Anything else counts as
  /// scheduled.
  static PatientFileBookingStatus fromApi(Object? value) =>
      value == 'completed' ? completed : scheduled;

  String get label => this == completed ? "منتهي" : "مجدول";
}

/// The patient's name, photo and age, shared by both tabs.
class PatientFilePatientModel {
  const PatientFilePatientModel({
    required this.name,
    required this.photoUrl,
    required this.age,
    this.country = '',
  });

  final String name;

  /// Null when the patient has no photo.
  final String? photoUrl;

  /// In years; null when the patient has no birth date.
  final int? age;

  /// Arabic country name — "ملفات المرضى القدامى" only.
  final String country;

  factory PatientFilePatientModel.fromJson(Object? value) {
    final json = value is Map ? value : const {};
    final photo = json['profileImage']?.toString().trim() ?? '';
    return PatientFilePatientModel(
      name: json['name']?.toString().trim() ?? '',
      photoUrl: photo.isEmpty ? null : photo,
      age: (json['age'] as num?)?.toInt(),
      country: json['country']?.toString().trim() ?? '',
    );
  }
}

/// One row of "ملفات مفتوحة بالصلاحية": a booking whose patient-data access
/// is still open.
class OpenPatientFileModel {
  const OpenPatientFileModel({
    required this.bookingId,
    required this.patient,
    required this.examinationDate,
    required this.status,
    required this.accessExpiresAt,
  });

  /// Opens the medical file (PatientMedicalFileLauncher).
  final String bookingId;
  final PatientFilePatientModel patient;
  final DateTime? examinationDate;
  final PatientFileBookingStatus status;

  /// End of the data-access window, in device time.
  final DateTime? accessExpiresAt;

  factory OpenPatientFileModel.fromJson(Map<String, dynamic> json) {
    DateTime? instant(Object? value) =>
        value is String ? DateTime.tryParse(value)?.toLocal() : null;
    return OpenPatientFileModel(
      bookingId: json['bookingId']?.toString() ?? '',
      patient: PatientFilePatientModel.fromJson(json['patient']),
      examinationDate: instant(json['examinationDate']),
      status: PatientFileBookingStatus.fromApi(json['status']),
      accessExpiresAt: instant(json['accessExpiresAt']),
    );
  }

  static List<OpenPatientFileModel> listFromJson(Object? value) => (value
              is List
          ? value
          : const [])
      .whereType<Map>()
      .map((e) => OpenPatientFileModel.fromJson(Map<String, dynamic>.from(e)))
      .where((file) => file.bookingId.isNotEmpty)
      .toList();
}

/// One row of "ملفات المرضى القدامى": a patient the doctor examined before.
class PreviousPatientModel {
  const PreviousPatientModel({
    required this.patientId,
    required this.patient,
    required this.lastExaminationDate,
    required this.lastType,
  });

  /// Opens "روشتات المريض".
  final String patientId;
  final PatientFilePatientModel patient;
  final DateTime? lastExaminationDate;

  /// "كشف" or "استشارة" — the type of the last booking.
  final AppointmentType lastType;

  factory PreviousPatientModel.fromJson(Map<String, dynamic> json) {
    final date = json['lastExaminationDate'];
    return PreviousPatientModel(
      patientId: json['patientId']?.toString() ?? '',
      patient: PatientFilePatientModel.fromJson(json['patient']),
      lastExaminationDate:
          date is String ? DateTime.tryParse(date)?.toLocal() : null,
      lastType: AppointmentType.fromApi(json['lastType']?.toString()),
    );
  }

  static List<PreviousPatientModel> listFromJson(Object? value) => (value
              is List
          ? value
          : const [])
      .whereType<Map>()
      .map((e) => PreviousPatientModel.fromJson(Map<String, dynamic>.from(e)))
      .where((patient) => patient.patientId.isNotEmpty)
      .toList();
}

extension AppointmentTypeLabel on AppointmentType {
  String get label => this == AppointmentType.consultation ? "استشارة" : "كشف";
}
