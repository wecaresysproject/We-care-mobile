import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/allergy/data/repos/allergy_data_entry_repo.dart';

part 'allergy_data_entry_state.dart';

class AllergyDataEntryCubit extends Cubit<AllergyDataEntryState> {
  AllergyDataEntryCubit(this._allergyDataEntryRepo)
      : super(
          AllergyDataEntryState.initialState(),
        );
  final AllergyDataEntryRepo _allergyDataEntryRepo;
  final personalNotesController = TextEditingController();
  final suergeryDescriptionController = TextEditingController(); // وصف اضافي
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

  Future<void> updateIsAtRiskOfAnaphylaxis(String? value) async {
    emit(state.copyWith(isAtRiskOfAnaphylaxis: value));
  }

  Future<void> updateIsThereMedicalWarningOnExposure(String? value) async {
    emit(state.copyWith(isThereMedicalWarningOnExposure: value));
  }

  void updateSelectedHospitalCenter(String? selectedHospital) {
    emit(state.copyWith(selectedHospitalCenter: selectedHospital));
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

  void updateSelectedInternist(String? selectedInternist) {
    emit(state.copyWith(internistName: selectedInternist));
  }

  void updateSelectedSurgeonName(String? surgeonName) {
    emit(state.copyWith(surgeonName: surgeonName));
  }

  void updateSelectedCountry(String? selectedCountry) {
    emit(state.copyWith(selectedCountryName: selectedCountry));
  }

  void updateAllergyType(String? bodyPart) {
    emit(state.copyWith(alleryTypeSelection: bodyPart));
    validateRequiredFields();
  }

  void updateExpectedSideEffect(String? name) {
    emit(state.copyWith(expectedSideEffectSelection: name));
    validateRequiredFields();
  }

  void updateSurgeryStatus(String? bodyPart) {
    emit(state.copyWith(selectedSurgeryStatus: bodyPart));
  }

  Future<void> updateSymptomOnsetAfterExposure(String? val) async {
    emit(state.copyWith(symptomOnsetAfterExposure: val));
  }

  Future<void> updateSyptomSeverity(String? val) async {
    emit(state.copyWith(selectedSyptomSeverity: val));
  }

  // Future<void> updateSelectedAllergyCauses(String? value) async {
  //   emit(state.copyWith(selectedAllergyCauses: value));
  // }
  Future<void> updateSelectedAllergyCauses(String? value) async {
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
  Future<void> removeAllergyCause(String cause) async {
    List<String> currentCauses = List.from(state.selectedAllergyCauses);
    currentCauses.remove(cause);
    emit(state.copyWith(selectedAllergyCauses: currentCauses));
  }

  Future<void> intialRequestsForDataEntry() async {
    await emitGetAllSurgeriesRegions();
    await emitCountriesData();
    await emitGetSurgeryStatus();
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

  // Future<void> emitGetAllTechUsed() async {
  //   final response = await _allergyDataEntryRepo.getAllTechUsed(
  //     language: AppStrings.arabicLang,
  //     region: state.surgeryBodyPartSelection!,
  //     subRegion: state.selectedSubSurgery!,
  //     surgeryName: state.surgeryNameSelection!,
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           allTechUsed: response,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

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

  Future<void> emitGetSurgeryStatus() async {
    final response = await _allergyDataEntryRepo.getSurgeryStatus(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allSurgeryStatuses: response,
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

  Future<void> emitGetAllSubSurgeriesRegions(
      {required String selectedRegion}) async {
    final response = await _allergyDataEntryRepo.getAllSubSurgeriesRegions(
      language: AppStrings.arabicLang,
      region: selectedRegion,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            subSurgeryRegions: response,
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

  Future<void> emitSurgeryNamesBasedOnRegion(
      {required String region, required String subRegion}) async {
    final response = await _allergyDataEntryRepo.getSurgeryNamesBasedOnRegion(
      language: AppStrings.arabicLang,
      region: region,
      subRegion: subRegion,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            surgeryNames: response,
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

  Future<void> emitGetAllSurgeriesRegions() async {
    final response = await _allergyDataEntryRepo.getAllSurgeriesRegions(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            bodyParts: response,
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

  Future<void> emitCountriesData() async {
    final response = await _allergyDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response.map((e) => e.name).toList(),
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

  // Future<void> emitSurgeryPurpose() async {
  //   final response = await _allergyDataEntryRepo.getSurgeryPurpose(
  //     language: AppStrings.arabicLang,
  //     region: state.surgeryBodyPartSelection!,
  //     subRegion: state.selectedSubSurgery!,
  //     surgeryName: state.surgeryNameSelection!,
  //     techUsed: state.selectedTechUsed!,
  //   );

  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           surgeryPurpose: response,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

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

  // Future<void> postModuleData(S locale) async {
  //   final response = await _allergyDataEntryRepo.postModuleData(
  //     language: AppStrings.arabicLang,
  //     requestBody: SurgeryRequestBodyModel(
  //       surgeryDate: state.allergyDateSelection!,
  //       surgeryName: state.surgeryNameSelection!,
  //       surgeryRegion: state.surgeryBodyPartSelection!,
  //       subSurgeryRegion: state.selectedSubSurgery!,
  //       usedTechnique: state.selectedTechUsed!,
  //       surgeryDescription: suergeryDescriptionController.text.isEmpty
  //           ? locale.no_data_entered
  //           : suergeryDescriptionController.text,
  //       medicalReportImage:
  //           state.reportImageUploadedUrl ?? locale.no_data_entered,
  //       surgeryStatus: state.selectedSurgeryStatus ?? locale.no_data_entered,
  //       hospitalCenter: state.selectedHospitalCenter ?? locale.no_data_entered,
  //       surgeonName: state.surgeryNameSelection ?? locale.no_data_entered,
  //       anesthesiologistName: state.internistName ?? locale.no_data_entered,
  //       postSurgeryInstructions: suergeryDescriptionController.text.isEmpty
  //           ? locale.no_data_entered
  //           : suergeryDescriptionController.text,
  //       country: state.selectedCountryName ?? locale.no_data_entered,
  //       additionalNotes: personalNotesController.text.isEmpty
  //           ? locale.no_data_entered
  //           : personalNotesController.text,
  //     ),
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           message: response,
  //           surgeriesDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           surgeriesDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    suergeryDescriptionController.dispose();
    effectedFamilyMembers.dispose();
    precautions.dispose();
    return super.close();
  }
}
