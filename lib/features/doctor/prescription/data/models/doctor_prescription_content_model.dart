import 'package:we_care/features/doctor/prescription/data/models/prescription_lab_test_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_xray_model.dart';

/// The `prescription` object the doctor saves and reads back
/// (docs/doctor_prescription_backend.md §4).
class DoctorPrescriptionContentModel {
  const DoctorPrescriptionContentModel({
    this.diagnosis = '',
    this.medicines = const [],
    this.manualMedicines = const [],
    this.xRays = const [],
    this.manualXRays = const [],
    this.labTests = const [],
    this.manualLabTests = const [],
    this.endoscopies = const [],
    this.additionalExaminations = const [],
    this.patientInstructions = const [],
  });

  factory DoctorPrescriptionContentModel.fromJson(Map<String, dynamic> json) {
    List<T> objects<T>(String key, T Function(Map<String, dynamic>) parse) => [
          for (final item in json[key] as List<dynamic>? ?? const [])
            if (item is Map<String, dynamic>) parse(item),
        ];
    List<PrescriptionManualEntryModel> texts(String key) => [
          for (final item in json[key] as List<dynamic>? ?? const [])
            if (item != null && item.toString().trim().isNotEmpty)
              PrescriptionManualEntryModel.fromJson(item),
        ];

    return DoctorPrescriptionContentModel(
      diagnosis: json['diagnosis']?.toString() ?? '',
      medicines: objects('medicines', PrescriptionMedicineModel.fromJson),
      manualMedicines: texts('manualMedicines'),
      xRays: objects('xRays', PrescriptionXRayModel.fromJson),
      manualXRays: texts('manualXRays'),
      labTests: objects('labTests', PrescriptionLabTestModel.fromJson),
      manualLabTests: texts('manualLabTests'),
      endoscopies: texts('endoscopies'),
      additionalExaminations: texts('additionalExaminations'),
      patientInstructions: texts('patientInstructions'),
    );
  }

  final String diagnosis;
  final List<PrescriptionMedicineModel> medicines;
  final List<PrescriptionManualEntryModel> manualMedicines;
  final List<PrescriptionXRayModel> xRays;
  final List<PrescriptionManualEntryModel> manualXRays;
  final List<PrescriptionLabTestModel> labTests;
  final List<PrescriptionManualEntryModel> manualLabTests;
  final List<PrescriptionManualEntryModel> endoscopies;
  final List<PrescriptionManualEntryModel> additionalExaminations;
  final List<PrescriptionManualEntryModel> patientInstructions;

  /// Every array is always sent; an empty section is `[]`.
  Map<String, dynamic> toJson() => {
        'diagnosis': diagnosis.trim(),
        'medicines': [for (final m in medicines) m.toJson()],
        'manualMedicines': [for (final m in manualMedicines) m.toJson()],
        'xRays': [for (final x in xRays) x.toJson()],
        'manualXRays': [for (final x in manualXRays) x.toJson()],
        'labTests': [for (final t in labTests) t.toJson()],
        'manualLabTests': [for (final t in manualLabTests) t.toJson()],
        'endoscopies': [for (final e in endoscopies) e.toJson()],
        'additionalExaminations': [
          for (final e in additionalExaminations) e.toJson(),
        ],
        'patientInstructions': [
          for (final i in patientInstructions) i.toJson()
        ],
      };
}

/// What `GET`/`PUT .../bookings/prescription` return in `data` (§3a).
class SavedDoctorPrescriptionModel {
  const SavedDoctorPrescriptionModel({
    required this.patientPrescriptionId,
    required this.createdAt,
    required this.editedAt,
    required this.images,
    required this.content,
  });

  factory SavedDoctorPrescriptionModel.fromJson(Map<String, dynamic> json) {
    final prescription = json['prescription'];
    return SavedDoctorPrescriptionModel(
      patientPrescriptionId: json['patientPrescriptionId']?.toString(),
      createdAt: _date(json['createdAt']),
      editedAt: _date(json['editedAt']),
      images: [
        for (final image in json['images'] as List<dynamic>? ?? const [])
          image.toString(),
      ],
      content: prescription is Map<String, dynamic>
          ? DoctorPrescriptionContentModel.fromJson(prescription)
          : const DoctorPrescriptionContentModel(),
    );
  }

  static DateTime? _date(Object? value) =>
      value == null ? null : DateTime.tryParse(value.toString())?.toLocal();

  /// The ticket created in the patient's prescriptions module.
  final String? patientPrescriptionId;
  final DateTime? createdAt;

  /// Null when it was saved once and never edited.
  final DateTime? editedAt;
  final List<String> images;
  final DoctorPrescriptionContentModel content;
}
