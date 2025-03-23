import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_%20complaints/data/models/medical_complaint_model.dart';

import '../../../data/repos/emergency_complaints_data_entry_repo.dart';

part 'emergency_complaints_data_entry_state.dart';

class EmergencyComplaintsDataEntryCubit
    extends Cubit<EmergencyComplaintsDataEntryState> {
  EmergencyComplaintsDataEntryCubit(this._emergencyDataEntryRepo)
      : super(
          EmergencyComplaintsDataEntryState.initialState(),
        );
  final EmergencyComplaintsDataEntryRepo _emergencyDataEntryRepo;
  final personalInfoController = TextEditingController();
  final complaintDiagnosisController = TextEditingController(); // التشخيص

  final medicineNameController = TextEditingController(); // اسم الدواء
  final medicineDoseController = TextEditingController(); // الجرعه
  final emergencyInterventionTypeController =
      TextEditingController(); // نوع التدخل

  List<MedicalComplaint> medicalComplaints = [];

  Future<void> getAllRequestsForAddingNewComplaintView() async {
    getAllComplaintsPlaces();
  }

  Future<void> getAllComplaintsPlaces() async {
    final response = await _emergencyDataEntryRepo.getAllPlacesOfComplaints(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (complaints) {
        emit(
          state.copyWith(
            complaintPlaces: complaints,
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
  void updateDateOfComplaint(String? date) {
    emit(state.copyWith(complaintAppearanceDate: date));
    validateRequiredFields();
  }

  void updateIfHasSameComplaintBeforeDate(String? date) {
    emit(state.copyWith(previousComplaintDate: date));
  }

  void updateEmergencyInterventionDate(String? date) {
    emit(state.copyWith(emergencyInterventionDate: date));
  }

  void updateSymptomsDiseaseRegion(String? symptom) {
    emit(state.copyWith(symptomsDiseaseRegion: symptom));
    validateRequiredFields();
    validateAddNewComplaintRequiredForms();
  }

  void updateNatureOfComplaint(String? type) {
    emit(state.copyWith(natureOfComplaint: type));
    validateRequiredFields();
    validateAddNewComplaintRequiredForms();
  }

  void updateMedicalSymptomsIssue(String? issue) {
    emit(state.copyWith(medicalSymptomsIssue: issue));
    validateRequiredFields();
    validateAddNewComplaintRequiredForms();
  }

  void updateComplaintDegree(String? intensity) {
    emit(state.copyWith(complaintDegree: intensity));
    validateRequiredFields();
    validateAddNewComplaintRequiredForms();
  }

  bool updateHasPreviousComplaintBefore(String? result) {
    bool hasComplaint = result == 'نعم';

    emit(
      state.copyWith(
        hasSimilarComplaintBefore: result,
        firstQuestionAnswer: hasComplaint,
      ),
    );

    validateRequiredFields(); // Ensure this method is called

    return hasComplaint;
  }

  bool updateIsTakingMedicines(String? result) {
    bool isTakingMedicine = result == 'نعم';

    emit(
      state.copyWith(
        isCurrentlyTakingMedication: result,
        secondQuestionAnswer: isTakingMedicine,
      ),
    );

    validateRequiredFields(); // Ensure validation runs

    return isTakingMedicine;
  }

  bool updateHasReceivedEmergencyCareBefore(String? result) {
    bool hasReceivedCare = result == 'نعم';

    emit(state.copyWith(
      hasReceivedEmergencyCareBefore: result,
      thirdQuestionAnswer: hasReceivedCare,
    ));

    validateRequiredFields(); // Ensure validation runs

    return hasReceivedCare;
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForEmergencyDataEntry() async {}

  void validateRequiredFields() {
    if (state.complaintAppearanceDate == null ||
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

  void validateAddNewComplaintRequiredForms() {
    if (state.symptomsDiseaseRegion == null ||
        state.natureOfComplaint == null ||
        state.medicalSymptomsIssue == null ||
        state.complaintDegree == null) {
      emit(
        state.copyWith(
          isAddNewComplaintFormsValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isAddNewComplaintFormsValidated: true,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    complaintDiagnosisController.dispose();
    medicineNameController.dispose();
    medicineDoseController.dispose();
    emergencyInterventionTypeController.dispose();

    return super.close();
  }
}
