import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicinesDataEntryCubit extends Cubit<MedicinesDataEntryState> {
  MedicinesDataEntryCubit(this._emergencyDataEntryRepo)
      : super(
          MedicinesDataEntryState.initialState(),
        );
  // ignore: unused_field
  final MedicinesDataEntryRepo _emergencyDataEntryRepo;
  final personalInfoController = TextEditingController();

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
  // void updateIfHasSameComplaintBeforeDate(String? date) {
  //   emit(state.copyWith(previousComplaintDate: date));
  // }

  // void updateEmergencyInterventionDate(String? date) {
  //   emit(state.copyWith(emergencyInterventionDate: date));
  // }

  // bool updateHasPreviousComplaintBefore(String? result) {
  //   bool hasComplaint = result == 'نعم';

  //   emit(
  //     state.copyWith(
  //       hasSimilarComplaintBefore: result,
  //       firstQuestionAnswer: hasComplaint,
  //     ),
  //   );

  //   validateRequiredFields(); // Ensure this method is called

  //   return hasComplaint;
  // }

  // bool updateIsTakingMedicines(String? result) {
  //   bool isTakingMedicine = result == 'نعم';

  //   emit(
  //     state.copyWith(
  //       isCurrentlyTakingMedication: result,
  //       secondQuestionAnswer: isTakingMedicine,
  //     ),
  //   );

  //   validateRequiredFields(); // Ensure validation runs

  //   return isTakingMedicine;
  // }

  // bool updateHasReceivedEmergencyCareBefore(String? result) {
  //   bool hasReceivedCare = result == 'نعم';

  //   emit(state.copyWith(
  //     hasReceivedEmergencyCareBefore: result,
  //     thirdQuestionAnswer: hasReceivedCare,
  //   ));

  //   validateRequiredFields(); // Ensure validation runs

  //   return hasReceivedCare;
  // }

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
  Future<void> close() {
    personalInfoController.dispose();

    return super.close();
  }
}
