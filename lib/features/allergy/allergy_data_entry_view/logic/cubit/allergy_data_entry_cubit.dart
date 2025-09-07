import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/allergy/data/models/post_allergy_module_data_model.dart';
import 'package:we_care/features/allergy/data/repos/allergy_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'allergy_data_entry_state.dart';

class AllergyDataEntryCubit extends Cubit<AllergyDataEntryState> {
  AllergyDataEntryCubit(this._allergyDataEntryRepo)
      : super(
          AllergyDataEntryState.initialState(),
        );
  final AllergyDataEntryRepo _allergyDataEntryRepo;
  final personalNotesController = TextEditingController();
  final effectedFamilyMembers = TextEditingController();
  final precautions = TextEditingController(); // الاحتياطات

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
  void updateAllergyDate(String? date) {
    emit(state.copyWith(allergyDateSelection: date));
    validateRequiredFields();
  }

  void updateIsAtRiskOfAnaphylaxis(String? value) {
    emit(state.copyWith(isAtRiskOfAnaphylaxis: value));
  }

  void updateIsThereMedicalWarningOnExposure(String? value) {
    emit(state.copyWith(isThereMedicalWarningOnExposure: value));
  }

  void updateIsDoctorConsulted(bool? val) {
    emit(state.copyWith(isDoctorConsulted: val));
  }

  void updateIsAllergyTestDone(bool? val) {
    emit(state.copyWith(isAllergyTestDn: val));
  }

  void isEpinephrineInjectorCarried(bool? val) {
    emit(state.copyWith(isEpinephrineInjectorCarried: val));
  }

  void updateIsTreatmentsEffective(bool? val) {
    emit(state.copyWith(isTreatmentsEffective: val));
  }

  void updateAllergyType(String? bodyPart) {
    emit(state.copyWith(alleryTypeSelection: bodyPart));
    emitAlleryTriggersBasedOnSelectedAllergyType();
    validateRequiredFields();
  }

  void updateExpectedSideEffect(String? name) {
    emit(state.copyWith(expectedSideEffectSelection: name));
    validateRequiredFields();
  }

  void updateSymptomOnsetAfterExposure(String? val) {
    emit(state.copyWith(symptomOnsetAfterExposure: val));
  }

  void updateSyptomSeverity(String? val) {
    emit(state.copyWith(selectedSyptomSeverity: val));
  }

  void updateSelectedAllergyCauses(String? value) {
    if (value == null || value.isEmpty) return;

    List<String> currentCauses = List.from(state.selectedAllergyCauses);

    // Toggle selection - if already selected, remove it; otherwise add it
    if (currentCauses.contains(value)) {
      currentCauses.remove(value);
    } else {
      currentCauses.add(value);
    }

    emit(state.copyWith(selectedAllergyCauses: currentCauses));
    validateRequiredFields();
  }

// Add a method to remove a specific cause
  void removeAllergyCause(String cause) {
    List<String> currentCauses = List.from(state.selectedAllergyCauses);
    currentCauses.remove(cause);
    emit(state.copyWith(selectedAllergyCauses: currentCauses));
  }

  Future<void> intialRequestsForDataEntry() async {
    await emitGetAllAllergyTypes();
  }

  Future<void> uploadReportImagePicked({required String imagePath}) async {
    emit(
      state.copyWith(
        uploadReportStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _allergyDataEntryRepo.uploadReportImage(
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

  // Future<void> submitUpdatedSurgery() async {
  //   emit(
  //     state.copyWith(
  //       surgeriesDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _allergyDataEntryRepo.updateSurgeryDocumentById(
  //     langauge: AppStrings.arabicLang,
  //     requestBody: SurgeryRequestBodyModel(
  //       surgeryDate: state.surgeryDateSelection!,
  //       surgeryRegion: state.surgeryBodyPartSelection!,
  //       subSurgeryRegion: state.selectedSubSurgery!,
  //       surgeryName: state.surgeryNameSelection!,
  //       usedTechnique: state.selectedTechUsed!,
  //       additionalNotes: personalNotesController.text,
  //       surgeryDescription: suergeryDescriptionController.text,
  //       postSurgeryInstructions: postSurgeryInstructions.text,
  //       surgeryStatus: state.selectedSurgeryStatus!,
  //       hospitalCenter: state.selectedHospitalCenter!,
  //       anesthesiologistName: state.internistName!,
  //       country: state.selectedCountryName!,
  //       surgeonName: state.surgeonName!,
  //       medicalReportImage: state.reportImageUploadedUrl!,
  //     ),
  //     id: state.updatedSurgeryId,
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           surgeriesDataEntryStatus: RequestStatus.success,
  //           message: successMessage,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           surgeriesDataEntryStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> emitAlleryTriggersBasedOnSelectedAllergyType() async {
    final response = await _allergyDataEntryRepo.getAllergyTriggers(
      language: AppStrings.arabicLang,
      allergyType: state.alleryTypeSelection!,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allergyTriggers: response,
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
  // المناطق العمليه الفرعيه

  Future<void> emitGetAllAllergyTypes() async {
    final response = await _allergyDataEntryRepo.getAllAllergyTypes(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allergyTypes: response,
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

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.allergyDateSelection == null ||
        state.alleryTypeSelection == null) {
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

  void updateSelectedMedicineName(String? medicineName) {
    log('xxx updateSelectedMedicineName: $medicineName');
    emit(state.copyWith(selectedMedicineName: medicineName));
  }

  Future<void> postModuleData(S locale) async {
    emit(
      state.copyWith(
        allergyDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _allergyDataEntryRepo.postAllergyModuleData(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: PostAllergyModuleDataModel(
        allergyOccurrenceDate: state.allergyDateSelection!,
        allergyType: state.alleryTypeSelection!,
        allergyTriggers: state.allergyTriggers.isEmpty
            ? [locale.no_data_entered]
            : state.allergyTriggers,
        expectedSideEffects:
            state.expectedSideEffectSelection ?? locale.no_data_entered,
        symptomSeverity: state.selectedSyptomSeverity ?? locale.no_data_entered,
        timeToSymptomOnset:
            state.symptomOnsetAfterExposure ?? locale.no_data_entered,
        isDoctorConsulted: state.isDoctorConsulted,
        isAllergyTestPerformed: state.isAllergyTestDn,
        medicationName: state.selectedMedicineName ?? locale.no_data_entered,
        isTreatmentsEffective: state.isTreatmentsEffective,
        medicalReportImage:
            state.reportImageUploadedUrl ?? locale.no_data_entered,
        familyHistory: effectedFamilyMembers.text.isEmpty
            ? locale.no_data_entered
            : effectedFamilyMembers.text,
        precautions: precautions.text.isEmpty
            ? locale.no_data_entered
            : precautions.text,
        proneToAllergies: state.isAtRiskOfAnaphylaxis ?? locale.no_data_entered,
        isMedicalWarningReceived:
            state.isThereMedicalWarningOnExposure ?? locale.no_data_entered,
        carryEpinephrine: state.isEpinephrineInjectorCarried,
      ),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response,
            allergyDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            allergyDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    effectedFamilyMembers.dispose();
    precautions.dispose();
    return super.close();
  }
}
