import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_data_entry_repo.dart';

part 'medical_complaint_details_state.dart';

class MedicalComplaintDataEntryDetailsCubit
    extends Cubit<MedicalComplaintDataEntryDetailsState> {
  MedicalComplaintDataEntryDetailsCubit(this._emergencyComplaintsDataEntryRepo)
      : super(MedicalComplaintDataEntryDetailsState.initial());
  final EmergencyComplaintsDataEntryRepo _emergencyComplaintsDataEntryRepo;

  List<MedicalComplaint> medicalComplaints = [];

  Future<void> saveNewMedicalComplaint() async {
    medicalComplaints.add(
      MedicalComplaint(
        symptomsRegion: state.symptomsDiseaseRegion!,
        sypmptomsComplaintIssue: state.medicalSymptomsIssue!,
        natureOfComplaint: state.natureOfComplaint!,
        severityOfComplaint: state.complaintDegree!,
      ),
    );
    emit(
      state.copyWith(
        isNewComplaintAddedSuccefully: true,
      ),
    );
    await resetCubitToInitialStates();
  }

  Future<void> getAllRequestsForAddingNewComplaintView() async {
    await getAllComplaintsPlaces();
  }

  Future<void> getAllComplaintsPlaces() async {
    final response =
        await _emergencyComplaintsDataEntryRepo.getAllPlacesOfComplaints(
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

  Future<void> getAllRelevantComplaintsToSelectedBodyPart(
      String selectedBodyPartName) async {
    final response = await _emergencyComplaintsDataEntryRepo
        .getAllComplaintsRelevantToBodyPartName(
      // language: AppStrings.arabicLang,
      bodyPartName: selectedBodyPartName,
    );
    response.when(
      success: (complaints) {
        emit(
          state.copyWith(
            releatedComplaintsToSelectedBodyPartName: complaints,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(),
        );
      },
    );
  }

  void removeNewMedicalComplaint(int index) {
    medicalComplaints.remove(medicalComplaints[index]);
  }

  void validateRequiredFields() {
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

  Future<void> updateSymptomsDiseaseRegion(String? symptom) async {
    emit(state.copyWith(symptomsDiseaseRegion: symptom));
    await getAllRelevantComplaintsToSelectedBodyPart(symptom!);
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

  Future<void> resetCubitToInitialStates() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    emit(
      MedicalComplaintDataEntryDetailsState.initial(),
    );
    validateRequiredFields();
  }

  resetCubitState() {
    medicalComplaints = [];
  }
}
