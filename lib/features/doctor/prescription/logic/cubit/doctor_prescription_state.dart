part of 'doctor_prescription_cubit.dart';

@immutable
class DoctorPrescriptionState extends Equatable {
  const DoctorPrescriptionState({
    this.loadStatus = RequestStatus.initial,
    this.saveStatus = RequestStatus.initial,
    this.message,
    this.createdAt,
    this.editedAt,
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

  /// Reading what was already saved for the booking. The form shows only
  /// once this succeeds, so a failed read can't be overwritten by an empty
  /// save.
  final RequestStatus loadStatus;

  /// "حفظ وإرسال": building the images, uploading them and saving.
  final RequestStatus saveStatus;

  /// The last load/save error, or the save success text.
  final String? message;

  /// First save — null until the prescription is sent to the patient.
  final DateTime? createdAt;

  /// Last edit after the first save — null if never edited.
  final DateTime? editedAt;

  /// Sent to the patient at least once; saving again edits the same ticket.
  bool get isSaved => createdAt != null;

  /// التشخيص — optional free text.
  final String diagnosis;

  /// Picked from the medicines lists (name, form, amount, ...).
  final List<PrescriptionMedicineModel> medicines;

  /// Medicines written by hand as free text.
  final List<PrescriptionManualEntryModel> manualMedicines;

  /// الأشعة — picked from the X-ray lists.
  final List<PrescriptionXRayModel> xRays;

  /// الأشعة — written by hand as free text.
  final List<PrescriptionManualEntryModel> manualXRays;

  /// التحاليل — picked from the lab tests lists.
  final List<PrescriptionLabTestModel> labTests;

  /// التحاليل — written by hand as free text.
  final List<PrescriptionManualEntryModel> manualLabTests;

  /// المناظير — free text.
  final List<PrescriptionManualEntryModel> endoscopies;

  /// فحوصات إضافية — free text.
  final List<PrescriptionManualEntryModel> additionalExaminations;

  /// تعليمات للمريض — one entry per bullet.
  final List<PrescriptionManualEntryModel> patientInstructions;

  int get totalMedicines => medicines.length + manualMedicines.length;

  int get totalExaminations =>
      xRays.length +
      manualXRays.length +
      labTests.length +
      manualLabTests.length +
      endoscopies.length +
      additionalExaminations.length;

  /// No medicine, examination or instruction yet — saving is disabled.
  /// The diagnosis alone is not enough.
  bool get isEmpty =>
      totalMedicines == 0 &&
      totalExaminations == 0 &&
      patientInstructions.isEmpty;

  /// The `prescription` object the backend stores.
  DoctorPrescriptionContentModel toContent() => DoctorPrescriptionContentModel(
        diagnosis: diagnosis,
        medicines: medicines,
        manualMedicines: manualMedicines,
        xRays: xRays,
        manualXRays: manualXRays,
        labTests: labTests,
        manualLabTests: manualLabTests,
        endoscopies: endoscopies,
        additionalExaminations: additionalExaminations,
        patientInstructions: patientInstructions,
      );

  DoctorPrescriptionState copyWith({
    RequestStatus? loadStatus,
    RequestStatus? saveStatus,
    String? message,
    DateTime? createdAt,
    DateTime? editedAt,
    String? diagnosis,
    List<PrescriptionMedicineModel>? medicines,
    List<PrescriptionManualEntryModel>? manualMedicines,
    List<PrescriptionXRayModel>? xRays,
    List<PrescriptionManualEntryModel>? manualXRays,
    List<PrescriptionLabTestModel>? labTests,
    List<PrescriptionManualEntryModel>? manualLabTests,
    List<PrescriptionManualEntryModel>? endoscopies,
    List<PrescriptionManualEntryModel>? additionalExaminations,
    List<PrescriptionManualEntryModel>? patientInstructions,
  }) {
    return DoctorPrescriptionState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      // Cleared unless passed, so an old message isn't shown again.
      message: message,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      diagnosis: diagnosis ?? this.diagnosis,
      medicines: medicines ?? this.medicines,
      manualMedicines: manualMedicines ?? this.manualMedicines,
      xRays: xRays ?? this.xRays,
      manualXRays: manualXRays ?? this.manualXRays,
      labTests: labTests ?? this.labTests,
      manualLabTests: manualLabTests ?? this.manualLabTests,
      endoscopies: endoscopies ?? this.endoscopies,
      additionalExaminations:
          additionalExaminations ?? this.additionalExaminations,
      patientInstructions: patientInstructions ?? this.patientInstructions,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        saveStatus,
        message,
        createdAt,
        editedAt,
        diagnosis,
        medicines,
        manualMedicines,
        xRays,
        manualXRays,
        labTests,
        manualLabTests,
        endoscopies,
        additionalExaminations,
        patientInstructions,
      ];
}
