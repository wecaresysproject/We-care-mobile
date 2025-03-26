import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_data_entry_repo.dart';

part 'emergency_complaint_details_state.dart';

class EmergencyComplaintDataEntryDetailsCubit
    extends Cubit<MedicalComplaintDataEntryDetailsState> {
  EmergencyComplaintDataEntryDetailsCubit(
      this._emergencyComplaintsDataEntryRepo)
      : super(MedicalComplaintDataEntryDetailsState.initial());
  final EmergencyComplaintsDataEntryRepo _emergencyComplaintsDataEntryRepo;

  Future<void> saveNewMedicalComplaint() async {
    final newMedicalComplaint = MedicalComplaint(
      symptomsRegion: state.symptomsDiseaseRegion!,
      sypmptomsComplaintIssue: state.medicalSymptomsIssue!,
      natureOfComplaint: state.natureOfComplaint!,
      severityOfComplaint: state.complaintDegree!,
    );
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    await medicalComplaintsBox.add(newMedicalComplaint);

    emit(
      state.copyWith(
        isNewComplaintAddedSuccefully: true,
      ),
    );
  }

  Future<void> updateMedicalComplaint(
      int index, MedicalComplaint oldComplaintDetails) async {
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    final updatedMedicalComplaint = oldComplaintDetails.updateWith(
      symptomsRegion: state.symptomsDiseaseRegion,
      sypmptomsComplaintIssue: state.medicalSymptomsIssue,
      natureOfComplaint: state.natureOfComplaint,
      severityOfComplaint: state.complaintDegree,
    );
    if (index >= 0 && index < medicalComplaintsBox.length) {
      await medicalComplaintsBox.put(
        index,
        updatedMedicalComplaint,
      );

      emit(
        state.copyWith(
          isEditingComplaintSuccess: true,
          // isNewComplaintAddedSuccefully:
          //     true, //TODO: make sate for success in edit mode later
        ),
      );
    } else {
      emit(
        state.copyWith(
          isEditingComplaintSuccess: false,
          // isNewComplaintAddedSuccefully:
          //     true, //TODO: make sate for success in edit mode later
        ),
      );
      throw Exception("Invalid index: $index");
    }
  }

  Future<void> loadEmergencyDetailsViewForEditing(
      MedicalComplaint medicalComplaint) async {
    emit(
      state.copyWith(
        //  isNewComplaintAddedSuccefully: true,
        isEditingComplaint: true,
        symptomsDiseaseRegion: medicalComplaint.symptomsRegion,
        medicalSymptomsIssue: medicalComplaint.sypmptomsComplaintIssue,
        natureOfComplaint: medicalComplaint.natureOfComplaint,
        complaintDegree: medicalComplaint.severityOfComplaint,
      ),
    );
    validateRequiredFields();
    await getAllRequestsForAddingNewComplaintView();
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
}
