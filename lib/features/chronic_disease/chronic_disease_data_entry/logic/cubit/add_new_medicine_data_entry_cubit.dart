import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/matched_medicines_model.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';

part 'add_new_medicine_data_entry_state.dart';

class AddNewMedicineDataEntryCubit extends Cubit<AddNewMedicineDataEntryState> {
  AddNewMedicineDataEntryCubit(this._medicinesDataEntryRepo)
      : super(
          AddNewMedicineDataEntryState.initialState(),
        );

  final MedicinesDataEntryRepo _medicinesDataEntryRepo;

  Future<void> loadMedicinesDataEnteredForEditing(
    MedicineModel pastDataEntered,
  ) async {
    await storeTempUserPastComplaints(pastDataEntered.mainSymptoms);

    emit(
      state.copyWith(
        medicineStartDate: pastDataEntered.startDate,
        selectedMedicineName: pastDataEntered.medicineName,
        selectedMedicalForm: pastDataEntered.usageMethod,
        selectedDose: pastDataEntered.dosage,
        selectedNoOfDose: pastDataEntered.dosageFrequency,
        isEditMode: true,
        updatedDocumentId: pastDataEntered.id,
      ),
    );
    validateRequiredFields();
    await initialDataEntryRequests();
  }

  Future<void> storeTempUserPastComplaints(
      List<MedicalComplaint> emergencyComplaints) async {
    final medicalComplaintBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    // Loop through the list and store each complaint in the box
    for (var oldComplains in emergencyComplaints) {
      await medicalComplaintBox.add(oldComplains);
    }
  }

  Future<void> initialDataEntryRequests() async {
    await emitAllMedicinesNames();
    await emitAllDosageFrequencies();
    await getAllUsageCategories();
  }

  Future<void> emitAllMedicinesNames() async {
    emit(
      state.copyWith(
        medicinesNamesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllMedicinesNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        final medcineNames = response.map((e) => e.tradeName).toList();
        emit(
          state.copyWith(
            medicinesNames: medcineNames,
            // medicinesBasicInfo: response,
            medicinesNamesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            // isLoading: false,
            medicinesNamesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  void getMedcineIdByName(String selectedMedicineName) {
    for (final medcineInfo in state.medicinesBasicInfo!) {
      if (medcineInfo.tradeName == selectedMedicineName) {
        emit(
          state.copyWith(
            medicineId: medcineInfo.id,
          ),
        );
        return;
      }
    }
  }

  Future<void> emitMedicineforms() async {
    emit(
      state.copyWith(
        medicalFormsOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getMedcineForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      medicineId: state.medicineId,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicineForms: response,
            medicalFormsOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicalFormsOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> emitMedcineDosesByForms() async {
    emit(
      state.copyWith(
        medicalDosesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getMedcineDosesByForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicineId: state.medicineId,
      medicineForm: state.selectedMedicalForm ?? "", //TODO: handle this later
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicalDoses: response,
            medicalDosesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicalDosesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> emitAllDosageFrequencies() async {
    emit(
      state.copyWith(
        dosageFrequenciesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllDosageFrequencies(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            dosageFrequencies: response,
            dosageFrequenciesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            dosageFrequenciesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> getAllUsageCategories() async {
    emit(
      state.copyWith(
        allUsageCategoriesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllUsageCategories(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allUsageCategories: response,
            allUsageCategoriesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            allUsageCategoriesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> getMedicineDetails(String medicineId) async {
    final response = await _medicinesDataEntryRepo.getMedicineDetailsById(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicineId: medicineId,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
              // medicineDetails: response,
              ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  /// Update Field Values
  void updateStartMedicineDate(String? date) {
    emit(state.copyWith(medicineStartDate: date));
    validateRequiredFields();
  }

  Future<void> updateSelectedMedicineName(String? medicineName) async {
    emit(state.copyWith(selectedMedicineName: medicineName));
    validateRequiredFields();
    // getMedcineIdByName(medicineName!);
    // await emitMedicineforms();
  }

  Future<void> updateSelectedMedicalForm(String? form) async {
    emit(state.copyWith(selectedMedicalForm: form));
    await emitMedcineDosesByForms();
    validateRequiredFields();
  }

  void updateSelectedDose(String? dose) {
    emit(state.copyWith(selectedDose: dose));
    validateRequiredFields();
  }

  void updateSelectedDoseFrequency(String? noOfDose) {
    emit(state.copyWith(selectedNoOfDose: noOfDose));
    validateRequiredFields();
  }

  void validateRequiredFields() {
    if (state.medicineStartDate == null ||
        state.selectedMedicineName == null ||
        state.selectedMedicalForm == null ||
        state.selectedDose == null ||
        state.selectedNoOfDose == null) {
      emit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }
}
