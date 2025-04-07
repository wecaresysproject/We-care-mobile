import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicinesDataEntryCubit extends Cubit<MedicinesDataEntryState> {
  MedicinesDataEntryCubit(this._medicinesDataEntryRepo)
      : super(
          MedicinesDataEntryState.initialState(),
        );
  // ignore: unused_field
  final MedicinesDataEntryRepo _medicinesDataEntryRepo;
  final personalInfoController = TextEditingController();
  List<MedicalComplaint> medicalComplaints = [];
  Future<void> fetchAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      medicalComplaints = medicalComplaintBox.values.toList(growable: true);
      emit(
        state.copyWith(
          medicalComplaints: medicalComplaints,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          medicalComplaints: [],
          // errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> initialDataEntryRequests() async {
    await emitAllMedicinesNames();
  }

  Future<void> emitAllMedicinesNames() async {
    final response = await _medicinesDataEntryRepo.getAllMedicinesNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicinesNames: response,
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

  Future<void> removeAddedMedicalComplaint(int index) async {
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    if (index >= 0 && index < medicalComplaintsBox.length) {
      await medicalComplaintsBox.deleteAt(index);
    }
  }

  Future<void> clearAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      await medicalComplaintBox.clear();
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  /// Update Field Values
  void updateStartMedicineDate(String? date) {
    emit(state.copyWith(medicineStartDate: date));
    validateRequiredFields();
  }

  void updateSelectedMedicineName(String? date) {
    emit(state.copyWith(selectedMedicineName: date));
    validateRequiredFields();
  }

  void updateWayToUseMedicine(String? date) {
    emit(state.copyWith(wayToUseMedicine: date));
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

  void updateSelectedDoseDuration(String? doseDuration) {
    emit(state.copyWith(doseDuration: doseDuration));
    validateRequiredFields();
  }

  void updateSelectedTimePeriod(String? timePeriods) {
    emit(state.copyWith(timePeriods: timePeriods));
    validateRequiredFields();
  }

  void updateSelectedChronicDisease(String? value) {
    emit(state.copyWith(selectedChronicDisease: value));
  }

  Future<void> updateSymptomsDiseaseRegion(String? symptom) async {
    emit(state.copyWith(symptomsDiseaseRegion: symptom));
    // await getAllRelevantComplaintsToSelectedBodyPart(symptom!);
    validateRequiredFields();
  }

  void updateMedicalSymptomsIssue(String? issue) {
    emit(state.copyWith(medicalSymptomsIssue: issue));
    validateRequiredFields();
  }

  void updateSelectedDoctorName(String? value) {
    emit(state.copyWith(selectedDoctorName: value));
  }

  void validateRequiredFields() {
    if (state.medicineStartDate == null ||
        state.selectedMedicineName == null ||
        state.wayToUseMedicine == null ||
        state.selectedDose == null ||
        state.selectedNoOfDose == null ||
        state.doseDuration == null ||
        state.timePeriods == null) {
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

  @override
  Future<void> close() async {
    personalInfoController.dispose();
    await clearAllAddedComplaints();
    return super.close();
  }
}
