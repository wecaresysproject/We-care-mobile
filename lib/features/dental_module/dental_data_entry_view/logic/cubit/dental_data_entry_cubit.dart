import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/dental_module/data/repos/dental_data_entry_repo.dart';

part 'dental_data_entry_state.dart';

class DentalDataEntryCubit extends Cubit<DentalDataEntryState> {
  DentalDataEntryCubit(this._dentalDataEntryRepo)
      : super(
          DentalDataEntryState.initialState(),
        );
  final DentalDataEntryRepo _dentalDataEntryRepo;
  final additionalNotesController = TextEditingController();

  // Future<void> loadPastSurgeryDataForEditing(SurgeryModel pastSurgery) async {
  //   emit(
  //     state.copyWith(
  //       surgeryDateSelection: pastSurgery.surgeryDate,
  //       surgeryBodyPartSelection: pastSurgery.surgeryRegion,
  //       selectedSubSurgery: pastSurgery.subSurgeryRegion,
  //       surgeryNameSelection: pastSurgery.surgeryName,
  //       selectedTechUsed: pastSurgery.usedTechnique,
  //       surgeryPurpose: pastSurgery.purpose,
  //       reportImageUploadedUrl: pastSurgery.medicalReportImage,
  //       selectedSurgeryStatus: pastSurgery.surgeryStatus,
  //       selectedHospitalCenter: pastSurgery.hospitalCenter,
  //       internistName: pastSurgery.anesthesiologistName,
  //       selectedCountryName: pastSurgery.country,
  //       surgeonName: pastSurgery.surgeonName,
  //       isEditMode: true,
  //       updatedSurgeryId: pastSurgery.id,
  //     ),
  //   );
  //   personalNotesController.text = pastSurgery.additionalNotes;
  //   suergeryDescriptionController.text = pastSurgery.surgeryDescription;
  //   postSurgeryInstructions.text = pastSurgery.postSurgeryInstructions;

  //   validateRequiredFields();
  //   await intialRequestsForDataEntry();
  // }

  /// Update Field Values
  void updateStartIssueDate(String? date) {
    emit(state.copyWith(startIssueDateSelection: date));
    validateRequiredFields();
  }

  void updateMedicalProcedureDate(String? date) {
    emit(state.copyWith(medicalProcedureDateSelection: date));
  }

  Future<void> updatePrimaryMedicalProcedure(String? val) async {
    emit(state.copyWith(primaryMedicalProcedureSelection: val));
    await emitSecondaryMedicalProcedures();
  }

  void updateSecodaryMedicalProcedure(String? val) {
    emit(state.copyWith(secondaryMedicalProcedureSelection: val));
  }

  void updateOralPathologySelection(String? val) {
    emit(state.copyWith(oralPathologySelection: val));
  }

  void updateSelectedHospitalCenter(String? selectedHospital) {
    emit(state.copyWith(selectedHospitalCenter: selectedHospital));
  }

  void updateSelectedTreatingDoctor(String? val) {
    emit(state.copyWith(treatingDoctor: val));
  }

  void updateSelectedCountry(String? selectedCountry) {
    emit(state.copyWith(selectedCountryName: selectedCountry));
  }

  void updateTypeOfSyptom(String? value) {
    emit(state.copyWith(syptomTypeSelection: value));
    validateRequiredFields();
  }

  void updateNatureOfComplaint(String? val) {
    emit(state.copyWith(natureOfComplaintSelection: val));
    validateRequiredFields();
  }

  void updateSurroundingGumsStatus(String? status) {
    emit(state.copyWith(selectedSurroundingGumStatus: status));
  }

  Future<void> updateComplaintDegree(String? val) async {
    emit(state.copyWith(complaintDegree: val));
    validateRequiredFields();
  }

//مدة الاعراض
  Future<void> updateSyptomsPeriod(String? value) async {
    emit(state.copyWith(selectedSyptomsPeriod: value));
    validateRequiredFields();
  }

  Future<void> intialRequestsForDataEntry() async {
    await emitPrimaryMedicalProcedures();
    await emitComplainTypes();
    await emitComaplainsDurations();
    await emitComplainNatures();
    await emitDoctorNames();
    await emitAllGumsconditions();
    await emitAllOralMedicalTests();
    await emitCountriesData();
  }

  Future<void> uploadTeethReport({required String imagePath}) async {
    emit(
      state.copyWith(
        uploadReportStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _dentalDataEntryRepo.uploadTeethReport(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            reportImageUploadedUrl: response.reportUrl,
            uploadReportStatus: UploadReportRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            uploadReportStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitCountriesData() async {
    final response = await _dentalDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response,
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

  Future<void> emitComaplainsDurations() async {
    final response = await _dentalDataEntryRepo.getAllComaplainsDurations(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            complainDurations: response,
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

  Future<void> emitComplainNatures() async {
    final response = await _dentalDataEntryRepo.getAllComplainNatures(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            complainNatures: response,
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

  Future<void> emitComplainTypes() async {
    final response = await _dentalDataEntryRepo.getAllComplainTypes(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            complainTypes: response,
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

  Future<void> emitDoctorNames() async {
    final response = await _dentalDataEntryRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            doctorNames: response,
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

  Future<void> emitPrimaryMedicalProcedures() async {
    final response = await _dentalDataEntryRepo.getAllMainMedicalProcedure(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (mainProcedures) {
        emit(
          state.copyWith(
            mainProcedures: mainProcedures,
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

  Future<void> emitAllGumsconditions() async {
    final response = await _dentalDataEntryRepo.getAllGumsconditions(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (result) {
        emit(
          state.copyWith(
            allGumsConditions: result,
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

  Future<void> emitAllOralMedicalTests() async {
    final response = await _dentalDataEntryRepo.getAllOralMedicalTests(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (result) {
        emit(
          state.copyWith(
            allOralMedicalTests: result,
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

  Future<void> emitSecondaryMedicalProcedures() async {
    final response = await _dentalDataEntryRepo.getAllSecondaryMedicalProcedure(
      mainProcedure: state.primaryMedicalProcedureSelection ??
          "", //TODO: to change null to empty string
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (secondaryProcedures) {
        emit(
          state.copyWith(
            secondaryProcedures: secondaryProcedures,
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

  void validateRequiredFields() {
    if (state.startIssueDateSelection == null ||
        state.syptomTypeSelection == null ||
        state.selectedSyptomsPeriod == null ||
        state.natureOfComplaintSelection == null ||
        state.complaintDegree == null) {
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
    additionalNotesController.dispose();
    return super.close();
  }
}
