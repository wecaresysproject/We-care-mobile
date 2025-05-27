import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class GeneticDiseasesDataEntryCubit
    extends Cubit<GeneticDiseasesDataEntryState> {
  GeneticDiseasesDataEntryCubit(this._geneticDiseasesDataEntryRepo)
      : super(
          GeneticDiseasesDataEntryState.initialState(),
        );

  final GeneticDiseasesDataEntryRepo _geneticDiseasesDataEntryRepo;
  List<NewGeneticDiseaseModel> geneticDiseases = [];
  Future<void> fetchAllAddedGeneticDiseases() async {
    try {
      final geneticDiseasesBox =
          Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");
      geneticDiseases = geneticDiseasesBox.values.toList(growable: true);
      emit(
        state.copyWith(
          geneticDiseases: geneticDiseases,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          geneticDiseases: [],
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> removeAddedGeneticDisease(int index) async {
    final Box<NewGeneticDiseaseModel> geneticDiseasesBox =
        Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");

    if (index >= 0 && index < geneticDiseasesBox.length) {
      await geneticDiseasesBox.deleteAt(index);
    }
  }
  // Future<void> loadMedicinesDataEnteredForEditing(
  //   MedicineModel pastDataEntered,
  // ) async {
  //   await storeTempUserPastComplaints(pastDataEntered.mainSymptoms);

  //   emit(
  //     state.copyWith(
  //       medicineStartDate: pastDataEntered.startDate,
  //       selectedMedicineName: pastDataEntered.medicineName,
  //       selectedMedicalForm: pastDataEntered.usageMethod,
  //       selectedDose: pastDataEntered.dosage,
  //       selectedNoOfDose: pastDataEntered.dosageFrequency,
  //       doseDuration: pastDataEntered.usageDuration,
  //       timePeriods: pastDataEntered.timeDuration,
  //       selectedChronicDisease: pastDataEntered.chronicDiseaseMedicine,
  //       medicalComplaints: pastDataEntered.mainSymptoms,
  //       selectedDoctorName: pastDataEntered.doctorName,
  //       selectedAlarmTime: pastDataEntered.reminder,
  //       isEditMode: true,
  //       updatedDocumentId: pastDataEntered.id,
  //     ),
  //   );
  //   personalInfoController.text = pastDataEntered.personalNotes;
  //   validateRequiredFields();
  //   await initialDataEntryRequests();
  // }

  // Future<void> submitEditsForMedicine() async {
  //   emit(
  //     state.copyWith(
  //       medicinesDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response =
  //       await _medicinesDataEntryRepo.editSpecifcMedicineDataDetails(
  //     medicineId: state.updatedDocumentId,
  //     requestBody: MedicineDataEntryRequestBody(
  //       startDate: state.medicineStartDate!,
  //       medicineName: state.selectedMedicineName!,
  //       usageMethod: state.selectedMedicalForm!,
  //       dosage: state.selectedDose!,
  //       dosageFrequency: state.selectedNoOfDose!,
  //       usageDuration: state.doseDuration!,
  //       timeDuration: state.timePeriods!,
  //       chronicDiseaseMedicine: state.selectedChronicDisease!,
  //       doctorName: state.selectedDoctorName!,
  //       reminder: state.selectedAlarmTime!,
  //       reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
  //       personalNotes: personalInfoController.text,
  //       userMedicalComplaint: state.medicalComplaints,
  //     ),
  //     language: AppStrings.arabicLang,
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //   );

  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           medicinesDataEntryStatus: RequestStatus.success,
  //           message: successMessage,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           medicinesDataEntryStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> initialDataEntryRequests() async {}

  // Future<void> postMedicinesDataEntry(S locale) async {
  //   emit(
  //     state.copyWith(
  //       medicinesDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _geneticDiseasesDataEntryRepo.postMedicinesDataEntry(
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //     requestBody: MedicineDataEntryRequestBody(
  //       startDate: state.medicineStartDate!,
  //       medicineName: state.selectedMedicineName!,
  //       usageMethod: state.selectedMedicalForm!,
  //       dosage: state.selectedDose!,
  //       dosageFrequency: state.selectedNoOfDose!,
  //       usageDuration: state.doseDuration!,
  //       timeDuration: state.timePeriods!,
  //       chronicDiseaseMedicine: locale.no_data_entered,
  //       doctorName: state.selectedDoctorName ?? locale.no_data_entered,
  //       reminder: state.selectedAlarmTime ?? locale.no_data_entered,
  //       reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
  //       personalNotes: "",
  //       geneticDiseases: state.geneticDiseases,
  //     ),
  //     language: AppStrings.arabicLang,
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           message: successMessage,
  //           medicinesDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           medicinesDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  void updateSelectedAlarmTime(String? alarmTime) {
    emit(
      state.copyWith(
        selectedAlarmTime: alarmTime,
      ),
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
  }

  Future<void> updateSelectedMedicalForm(String? form) async {
    emit(state.copyWith(selectedMedicalForm: form));
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

  Future<void> updateSelectedDoseDuration(String? doseDuration) async {
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

  void updateSelectedDoctorName(String? value) {
    emit(state.copyWith(selectedDoctorName: value));
  }

  void validateRequiredFields() {
    if (state.medicineStartDate == null ||
        state.selectedMedicineName == null ||
        state.selectedMedicalForm == null ||
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

  Future<void> clearAllAddedComplaints() async {
    try {
      final geneticDiseasesBox =
          Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");
      await geneticDiseasesBox.clear();
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await clearAllAddedComplaints();

    return super.close();
  }
}
