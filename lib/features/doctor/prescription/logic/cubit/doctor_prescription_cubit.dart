import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/prescription/data/models/doctor_prescription_content_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_lab_test_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_manual_entry_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_xray_model.dart';
import 'package:we_care/features/doctor/prescription/data/repos/doctor_prescription_repo.dart';
import 'package:we_care/features/doctor/prescription/logic/doctor_prescription_document_builder.dart';

part 'doctor_prescription_state.dart';

/// The prescription the doctor writes during the call for one booking.
/// Opens with what was already saved, and "حفظ وإرسال" sends it to the
/// patient as page images plus the written data.
class DoctorPrescriptionCubit extends Cubit<DoctorPrescriptionState>
    with SafeEmitMixin {
  DoctorPrescriptionCubit(this._repo) : super(const DoctorPrescriptionState());

  final DoctorPrescriptionRepo _repo;
  final _documentBuilder = const DoctorPrescriptionDocumentBuilder();

  String _bookingId = '';
  String? _patientName;
  String _doctorName = '';
  String _doctorSpecialty = '';

  /// Loads what was saved for [bookingId] to fill the screen, and the
  /// doctor's name and specialty for the paper.
  Future<void> loadPrescription({
    required String bookingId,
    String? patientName,
  }) async {
    _bookingId = bookingId;
    _patientName = patientName;
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));

    final (result, _) =
        await (_repo.getPrescription(bookingId), _loadDoctorInfo()).wait;
    result.when(
      success: (saved) {
        final content = saved?.content;
        safeEmit(
          DoctorPrescriptionState(
            loadStatus: RequestStatus.success,
            createdAt: saved?.createdAt,
            editedAt: saved?.editedAt,
            diagnosis: content?.diagnosis ?? '',
            medicines: content?.medicines ?? const [],
            manualMedicines: content?.manualMedicines ?? const [],
            xRays: content?.xRays ?? const [],
            manualXRays: content?.manualXRays ?? const [],
            labTests: content?.labTests ?? const [],
            manualLabTests: content?.manualLabTests ?? const [],
            endoscopies: content?.endoscopies ?? const [],
            additionalExaminations: content?.additionalExaminations ?? const [],
            patientInstructions: content?.patientInstructions ?? const [],
          ),
        );
      },
      failure: (error) => safeEmit(
        state.copyWith(
          loadStatus: RequestStatus.failure,
          message: error.errors.firstOrNull,
        ),
      ),
    );
  }

  /// What the prescription paper shows — used by the preview and the save,
  /// so the patient gets exactly what the doctor previewed.
  /// [editedAt] overrides the saved edit time (a new save is an edit now).
  PrescriptionDocumentData documentData({DateTime? editedAt}) =>
      PrescriptionDocumentData(
        prescription: state,
        // The prescription is written during the call, on the booking day.
        date: state.createdAt ?? DateTime.now(),
        patientName: _patientName,
        doctorName: _doctorName,
        doctorSpecialty: _doctorSpecialty,
        editedAt: editedAt ?? (state.isSaved ? state.editedAt : null),
      );

  Future<void> _loadDoctorInfo() async {
    final info = await _repo.getDoctorInfo();
    _doctorName = info.name;
    _doctorSpecialty = info.specialty;
  }

  /// "حفظ وإرسال": builds the page images, uploads them and saves.
  Future<void> savePrescription() async {
    if (state.isEmpty || state.saveStatus == RequestStatus.loading) return;
    safeEmit(state.copyWith(saveStatus: RequestStatus.loading));

    final wasSaved = state.isSaved;
    final List<Uint8List> pages;
    try {
      // The patient must see who wrote it: try again if it failed on open.
      if (_doctorName.isEmpty) await _loadDoctorInfo();
      // A save after the first one is an edit — the paper shows it.
      pages = await _documentBuilder.buildPageImages(
        documentData(editedAt: wasSaved ? DateTime.now() : null),
      );
    } catch (error) {
      AppLogger.debug('❌ prescription images failed: $error');
      safeEmit(
        state.copyWith(
          saveStatus: RequestStatus.failure,
          message: 'تعذر تجهيز صور الروشتة، حاول مرة أخرى',
        ),
      );
      return;
    }

    final result = await _repo.savePrescription(
      bookingId: _bookingId,
      pageImages: pages,
      content: state.toContent(),
    );
    result.when(
      success: (saved) {
        final now = DateTime.now();
        safeEmit(
          state.copyWith(
            saveStatus: RequestStatus.success,
            message: wasSaved
                ? 'تم حفظ التعديلات وإرسالها للمريض'
                : 'تم حفظ الروشتة وإرسالها للمريض',
            createdAt: saved.createdAt ?? state.createdAt ?? now,
            editedAt: saved.editedAt ?? (wasSaved ? now : null),
          ),
        );
      },
      failure: (error) => safeEmit(
        state.copyWith(
          saveStatus: RequestStatus.failure,
          message: error.errors.firstOrNull ?? 'تعذر حفظ الروشتة',
        ),
      ),
    );
  }

  void updateDiagnosis(String diagnosis) =>
      safeEmit(state.copyWith(diagnosis: diagnosis));

  // ---------------------------------------------------------------------------
  // 1. الأدوية
  // ---------------------------------------------------------------------------

  void addMedicine(PrescriptionMedicineModel medicine) => safeEmit(
        state.copyWith(medicines: [...state.medicines, medicine]),
      );

  void updateMedicine(int index, PrescriptionMedicineModel medicine) =>
      safeEmit(
        state.copyWith(medicines: _replaced(state.medicines, index, medicine)),
      );

  void removeMedicine(int index) => safeEmit(
        state.copyWith(medicines: _removed(state.medicines, index)),
      );

  void addManualMedicine(PrescriptionManualEntryModel medicine) => safeEmit(
        state.copyWith(manualMedicines: [...state.manualMedicines, medicine]),
      );

  void updateManualMedicine(int index, PrescriptionManualEntryModel medicine) =>
      safeEmit(
        state.copyWith(
          manualMedicines: _replaced(state.manualMedicines, index, medicine),
        ),
      );

  void removeManualMedicine(int index) => safeEmit(
        state.copyWith(manualMedicines: _removed(state.manualMedicines, index)),
      );

  // ---------------------------------------------------------------------------
  // 2. الفحوصات
  // ---------------------------------------------------------------------------

  void addXRay(PrescriptionXRayModel xRay) =>
      safeEmit(state.copyWith(xRays: [...state.xRays, xRay]));

  void updateXRay(int index, PrescriptionXRayModel xRay) =>
      safeEmit(state.copyWith(xRays: _replaced(state.xRays, index, xRay)));

  void removeXRay(int index) =>
      safeEmit(state.copyWith(xRays: _removed(state.xRays, index)));

  void addManualXRay(PrescriptionManualEntryModel xRay) =>
      safeEmit(state.copyWith(manualXRays: [...state.manualXRays, xRay]));

  void updateManualXRay(int index, PrescriptionManualEntryModel xRay) =>
      safeEmit(
        state.copyWith(
          manualXRays: _replaced(state.manualXRays, index, xRay),
        ),
      );

  void removeManualXRay(int index) => safeEmit(
        state.copyWith(manualXRays: _removed(state.manualXRays, index)),
      );

  void addLabTest(PrescriptionLabTestModel labTest) =>
      safeEmit(state.copyWith(labTests: [...state.labTests, labTest]));

  void updateLabTest(int index, PrescriptionLabTestModel labTest) => safeEmit(
        state.copyWith(labTests: _replaced(state.labTests, index, labTest)),
      );

  void removeLabTest(int index) =>
      safeEmit(state.copyWith(labTests: _removed(state.labTests, index)));

  void addManualLabTest(PrescriptionManualEntryModel labTest) => safeEmit(
        state.copyWith(manualLabTests: [...state.manualLabTests, labTest]),
      );

  void updateManualLabTest(int index, PrescriptionManualEntryModel labTest) =>
      safeEmit(
        state.copyWith(
          manualLabTests: _replaced(state.manualLabTests, index, labTest),
        ),
      );

  void removeManualLabTest(int index) => safeEmit(
        state.copyWith(manualLabTests: _removed(state.manualLabTests, index)),
      );

  void addEndoscopy(PrescriptionManualEntryModel endoscopy) => safeEmit(
        state.copyWith(endoscopies: [...state.endoscopies, endoscopy]),
      );

  void updateEndoscopy(int index, PrescriptionManualEntryModel endoscopy) =>
      safeEmit(
        state.copyWith(
          endoscopies: _replaced(state.endoscopies, index, endoscopy),
        ),
      );

  void removeEndoscopy(int index) => safeEmit(
        state.copyWith(endoscopies: _removed(state.endoscopies, index)),
      );

  void addAdditionalExamination(PrescriptionManualEntryModel examination) =>
      safeEmit(
        state.copyWith(
          additionalExaminations: [
            ...state.additionalExaminations,
            examination,
          ],
        ),
      );

  void updateAdditionalExamination(
    int index,
    PrescriptionManualEntryModel examination,
  ) =>
      safeEmit(
        state.copyWith(
          additionalExaminations:
              _replaced(state.additionalExaminations, index, examination),
        ),
      );

  void removeAdditionalExamination(int index) => safeEmit(
        state.copyWith(
          additionalExaminations: _removed(state.additionalExaminations, index),
        ),
      );

  // ---------------------------------------------------------------------------
  // 3. تعليمات للمريض
  // ---------------------------------------------------------------------------

  void addPatientInstructions(
          List<PrescriptionManualEntryModel> instructions) =>
      safeEmit(
        state.copyWith(
          patientInstructions: [...state.patientInstructions, ...instructions],
        ),
      );

  void updatePatientInstruction(
    int index,
    PrescriptionManualEntryModel instruction,
  ) =>
      safeEmit(
        state.copyWith(
          patientInstructions:
              _replaced(state.patientInstructions, index, instruction),
        ),
      );

  void removePatientInstruction(int index) => safeEmit(
        state.copyWith(
          patientInstructions: _removed(state.patientInstructions, index),
        ),
      );

  /// A copy of [list] with [item] at [index] — unchanged if out of range.
  static List<T> _replaced<T>(List<T> list, int index, T item) {
    if (index < 0 || index >= list.length) return list;
    return [...list]..[index] = item;
  }

  /// A copy of [list] without [index] — unchanged if out of range.
  static List<T> _removed<T>(List<T> list, int index) {
    if (index < 0 || index >= list.length) return list;
    return [...list]..removeAt(index);
  }
}
