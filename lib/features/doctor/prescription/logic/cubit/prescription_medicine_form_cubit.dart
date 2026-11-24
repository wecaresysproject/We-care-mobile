import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_medicine_model.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';

part 'prescription_medicine_form_state.dart';

/// The add / edit medicine sheet of the doctor's prescription. Reuses the
/// medicines module's lookups (names, forms, amounts, frequencies) without its
/// data-entry flow.
class PrescriptionMedicineFormCubit extends Cubit<PrescriptionMedicineFormState>
    with SafeEmitMixin {
  PrescriptionMedicineFormCubit(this._medicinesRepo)
      : super(const PrescriptionMedicineFormState());

  final MedicinesDataEntryRepo _medicinesRepo;

  /// [initialMedicine] fills the form when editing an existing row.
  Future<void> init(PrescriptionMedicineModel? initialMedicine) async {
    if (initialMedicine != null) {
      safeEmit(
        state.copyWith(
          isEditMode: true,
          medicineId: () => initialMedicine.medicineId,
          selectedMedicineName: initialMedicine.name,
          selectedMedicalForm: () => initialMedicine.medicalForm,
          selectedDoseAmount: () => initialMedicine.doseAmount,
          selectedDoseFrequency: initialMedicine.doseFrequency,
          duration: initialMedicine.duration,
          instructions: initialMedicine.instructions,
        ),
      );
    }
    await Future.wait([
      loadMedicinesNames(),
      loadDosageFrequencies(),
      if (initialMedicine?.medicineId != null) loadMedicalForms(),
      if (initialMedicine != null) loadDoseAmounts(),
    ]);
  }

  Future<void> loadMedicinesNames() async {
    safeEmit(state.copyWith(namesLoadingState: OptionsLoadingState.loading));
    final response = await _medicinesRepo.getAllMedicinesNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (medicines) => safeEmit(
        state.copyWith(
          medicines: medicines,
          namesLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(namesLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  Future<void> loadDosageFrequencies() async {
    safeEmit(
      state.copyWith(frequenciesLoadingState: OptionsLoadingState.loading),
    );
    final response = await _medicinesRepo.getAllDosageFrequencies(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (frequencies) => safeEmit(
        state.copyWith(
          dosageFrequencies: frequencies,
          frequenciesLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(frequenciesLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  /// طريقة الاستخدام (الأشكال الدوائية) of the selected medicine — same
  /// lookup as the medicines module.
  Future<void> loadMedicalForms() async {
    final medicineId = state.medicineId;
    if (medicineId == null) {
      // A typed medicine name — the doctor writes the form by hand.
      safeEmit(
        state.copyWith(
          medicalForms: const [],
          formsLoadingState: OptionsLoadingState.loaded,
        ),
      );
      return;
    }
    safeEmit(state.copyWith(formsLoadingState: OptionsLoadingState.loading));
    final response = await _medicinesRepo.getMedcineForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      medicineId: medicineId,
    );
    // The doctor may have picked another medicine while this was loading.
    if (state.medicineId != medicineId) return;
    response.when(
      success: (forms) => safeEmit(
        state.copyWith(
          medicalForms: forms,
          formsLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(formsLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  /// كمية الدواء for the selected form — same lookup as the medicines
  /// module.
  Future<void> loadDoseAmounts() async {
    final medicalForm = state.selectedMedicalForm;
    if (medicalForm == null) {
      safeEmit(
        state.copyWith(
          doseAmounts: const [],
          doseAmountsLoadingState: OptionsLoadingState.loaded,
        ),
      );
      return;
    }
    safeEmit(
      state.copyWith(doseAmountsLoadingState: OptionsLoadingState.loading),
    );
    final response = await _medicinesRepo.getAllDoseAmounts(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicalForm: medicalForm,
    );
    // The doctor may have picked another form while this was loading.
    if (state.selectedMedicalForm != medicalForm) return;
    response.when(
      success: (amounts) => safeEmit(
        state.copyWith(
          doseAmounts: amounts,
          doseAmountsLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(doseAmountsLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  Future<void> updateMedicineName(String name) async {
    if (name == state.selectedMedicineName) return;
    final matches = state.medicines.where((m) => m.tradeName == name);
    safeEmit(
      state.copyWith(
        selectedMedicineName: name,
        medicineId: () => matches.isEmpty ? null : matches.first.id,
        // The old form and amount belong to the previous medicine.
        selectedMedicalForm: () => null,
        medicalForms: const [],
        selectedDoseAmount: () => null,
        doseAmounts: const [],
      ),
    );
    await loadMedicalForms();
  }

  Future<void> updateMedicalForm(String form) async {
    if (form == state.selectedMedicalForm) return;
    safeEmit(
      state.copyWith(
        selectedMedicalForm: () => form,
        // The old amount belongs to the previous form.
        selectedDoseAmount: () => null,
        doseAmounts: const [],
      ),
    );
    await loadDoseAmounts();
  }

  void updateDoseAmount(String amount) {
    safeEmit(state.copyWith(selectedDoseAmount: () => amount));
  }

  void updateDoseFrequency(String frequency) {
    safeEmit(state.copyWith(selectedDoseFrequency: frequency));
  }

  void updateDuration(String duration) {
    safeEmit(state.copyWith(duration: duration));
  }

  void updateInstructions(String instructions) {
    safeEmit(state.copyWith(instructions: instructions));
  }

  /// The filled row, or null while a required field is missing.
  PrescriptionMedicineModel? buildMedicine() {
    if (!state.isFormValid) return null;
    return PrescriptionMedicineModel(
      medicineId: state.medicineId,
      name: state.selectedMedicineName!.trim(),
      medicalForm: state.selectedMedicalForm!.trim(),
      doseAmount: state.selectedDoseAmount!.trim(),
      doseFrequency: state.selectedDoseFrequency!.trim(),
      duration: state.duration.trim(),
      instructions: state.instructions.trim(),
    );
  }
}
