import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

import '../../../data/repos/emergency_complaints_data_entry_repo.dart';

part 'emergency_complaints_data_entry_state.dart';

class EmergencyComplaintsDataEntryCubit
    extends Cubit<EmergencyComplaintsDataEntryState> {
  EmergencyComplaintsDataEntryCubit(this._emergencyDataEntryRepo)
      : super(
          EmergencyComplaintsDataEntryState.initialState(),
        );
  final EmergencyComplaintsDataEntryRepo _emergencyDataEntryRepo;

  final formKey = GlobalKey<FormState>();

  /// Update Field Values
  void updateDateOfComplaint(String? date) {
    emit(state.copyWith(complaintAppearanceDate: date));
    validateRequiredFields();
  }

  void updateComplaintLocation(String? complaintLocation) {
    emit(state.copyWith(complaintLocation: complaintLocation));
    validateRequiredFields();
  }

  void updateSymptomsDiseaseRegion(String? symptom) {
    emit(state.copyWith(symptomsDiseaseRegion: symptom));
    validateRequiredFields();
  }

  void updateNatureOfComplaint(String? type) {
    emit(state.copyWith(natureOfComplaint: type));
    validateRequiredFields();
  }

  void updateMedicalSymptomsIssue(String? issue) {
    emit(state.copyWith(medicalSymptomsIssue: issue));
    validateRequiredFields();
  }

  void updateComplaintDegree(String? intensity) {
    emit(state.copyWith(complaintDegree: intensity));
    validateRequiredFields();
  }

  bool updateHasPreviousComplaintBefore(String? result) {
    emit(state.copyWith(hasSimilarComplaintBefore: result));
    validateRequiredFields();
    return result == 'نعم' ? true : false;
  }

  bool updateIsTakingMedicines(String? result) {
    emit(state.copyWith(isCurrentlyTakingMedication: result));
    validateRequiredFields();
    return result == 'نعم' ? true : false;
  }

  bool updateHasReceivedEmergencyCareBefore(String? result) {
    emit(state.copyWith(hasReceivedEmergencyCareBefore: result));
    validateRequiredFields();
    return result == 'نعم' ? true : false;
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForEmergencyDataEntry() async {}

  void validateRequiredFields() {
    if (state.complaintAppearanceDate == null ||
        state.complaintLocation == null ||
        state.symptomsDiseaseRegion == null ||
        state.natureOfComplaint == null ||
        state.medicalSymptomsIssue == null ||
        state.complaintDegree == null ||
        state.hasSimilarComplaintBefore == null ||
        state.isCurrentlyTakingMedication == null ||
        state.hasReceivedEmergencyCareBefore == null) {
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
    formKey.currentState?.reset();
    return super.close();
  }
}
