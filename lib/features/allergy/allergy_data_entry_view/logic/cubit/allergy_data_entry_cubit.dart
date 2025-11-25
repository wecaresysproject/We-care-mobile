import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/allergy/data/models/allergy_details_data_model.dart';
import 'package:we_care/features/allergy/data/models/post_allergy_module_data_model.dart';
import 'package:we_care/features/allergy/data/repos/allergy_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'allergy_data_entry_state.dart';

class AllergyDataEntryCubit extends Cubit<AllergyDataEntryState> {
  AllergyDataEntryCubit(this._allergyDataEntryRepo, this._appSharedRepo)
      : super(
          AllergyDataEntryState.initialState(),
        );
  final AllergyDataEntryRepo _allergyDataEntryRepo;
  final AppSharedRepo _appSharedRepo;
  final effectedFamilyMembers = TextEditingController();
  final precautions = TextEditingController(); // الاحتياطات
  final reportTextController = TextEditingController();

  Future<void> loadpastAllergyDataForEditing(
      AllergyDetailsData pastAllergy, S locale) async {
    emit(
      state.copyWith(
        allergyDateSelection: pastAllergy.allergyOccurrenceDate,
        alleryTypeSelection: pastAllergy.allergyType,
        expectedSideEffects: pastAllergy.expectedSideEffects,
        selectedSyptomSeverity: pastAllergy.symptomSeverity,
        symptomOnsetAfterExposure: pastAllergy.timeToSymptomOnset,
        isDoctorConsulted: pastAllergy.isDoctorConsulted,
        isAllergyTestDn: pastAllergy.isAllergyTestPerformed,
        selectedMedicineName: pastAllergy.medicationName,
        isTreatmentsEffective: pastAllergy.isTreatmentsEffective,
        reportsUploadedUrls: pastAllergy.medicalReportImage,
        isAtRiskOfAnaphylaxis: pastAllergy.proneToAllergies,
        isThereMedicalWarningOnExposure: pastAllergy.isMedicalWarningReceived,
        isEpinephrineInjectorCarried: pastAllergy.carryEpinephrine,
        updatedDocId: pastAllergy.id,
        selectedAllergyCauses: pastAllergy.allergyTriggers,
        isEditMode: true,
      ),
    );
    effectedFamilyMembers.text =
        pastAllergy.familyHistory == locale.no_data_entered
            ? ""
            : pastAllergy.familyHistory!;
    precautions.text = pastAllergy.precautions == locale.no_data_entered
        ? ""
        : pastAllergy.precautions!;
    reportTextController.text = pastAllergy.writtenReport ?? "";
    validateRequiredFields();
    await intialRequestsForDataEntry();
  }

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

  Future<void> updateAllergyType(String? bodyPart) async {
    emit(state.copyWith(
      alleryTypeSelection: bodyPart,
      selectedAllergyCauses: [],
    ));
    await Future.wait([
      emitAlleryTriggersBasedOnSelectedAllergyType(),
      emitExpectedSideEffects(),
    ]);
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

  void removeUploadedReport(String url) {
    final updated = List<String>.from(state.reportsUploadedUrls)..remove(url);

    emit(
      state.copyWith(
        reportsUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadReportImagePicked({required String imagePath}) async {
    // 1) Check limit
    if (state.reportsUploadedUrls.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          uploadReportStatus: UploadReportRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        uploadReportStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _appSharedRepo.uploadReport(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final updatedReports = List<String>.from(state.reportsUploadedUrls)
          ..add(response.reportUrl);
        emit(
          state.copyWith(
            message: response.message,
            reportsUploadedUrls: updatedReports,
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

  Future<void> updateAllergyDocumentById() async {
    emit(
      state.copyWith(
        allergyDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _allergyDataEntryRepo.updateAllergyDocumentById(
      langauge: AppStrings.arabicLang,
      requestBody: PostAllergyModuleDataModel(
        writtenReport: reportTextController.text.isNotEmpty
            ? reportTextController.text
            : "",
        allergyOccurrenceDate: state.allergyDateSelection!,
        allergyType: state.alleryTypeSelection!,
        allergyTriggers: state.selectedAllergyCauses,
        expectedSideEffects: state.expectedSideEffects,
        symptomSeverity: state.selectedSyptomSeverity!,
        timeToSymptomOnset: state.symptomOnsetAfterExposure!,
        isDoctorConsulted: state.isDoctorConsulted,
        isAllergyTestPerformed: state.isAllergyTestDn,
        medicationName: state.selectedMedicineName!,
        isTreatmentsEffective: state.isTreatmentsEffective,
        medicalReportImage: state.reportsUploadedUrls,
        familyHistory: effectedFamilyMembers.text,
        precautions: precautions.text,
        proneToAllergies: state.isAtRiskOfAnaphylaxis,
        isMedicalWarningReceived: state.isThereMedicalWarningOnExposure,
        carryEpinephrine: state.isEpinephrineInjectorCarried,
      ),
      id: state.updatedDocId,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            allergyDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            allergyDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

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

  Future<void> emitExpectedSideEffects() async {
    final response = await _allergyDataEntryRepo.getExpectedSideEffects(
      language: AppStrings.arabicLang,
      allergyType: state.alleryTypeSelection!,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            expectedSideEffects: response,
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
    AppLogger.debug('xxx updateSelectedMedicineName: $medicineName');
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
        writtenReport: reportTextController.text.isNotEmpty
            ? reportTextController.text
            : locale.no_data_entered,
        allergyOccurrenceDate: state.allergyDateSelection!,
        allergyType: state.alleryTypeSelection!,
        allergyTriggers: state.selectedAllergyCauses,
        expectedSideEffects: state.expectedSideEffects,
        symptomSeverity: state.selectedSyptomSeverity ?? locale.no_data_entered,
        timeToSymptomOnset:
            state.symptomOnsetAfterExposure ?? locale.no_data_entered,
        isDoctorConsulted: state.isDoctorConsulted,
        isAllergyTestPerformed: state.isAllergyTestDn,
        medicationName: state.selectedMedicineName ?? locale.no_data_entered,
        isTreatmentsEffective: state.isTreatmentsEffective,
        medicalReportImage: state.reportsUploadedUrls,
        familyHistory: effectedFamilyMembers.text.isEmpty
            ? locale.no_data_entered
            : effectedFamilyMembers.text,
        precautions: precautions.text.isEmpty
            ? locale.no_data_entered
            : precautions.text,
        proneToAllergies: state.isAtRiskOfAnaphylaxis,
        isMedicalWarningReceived: state.isThereMedicalWarningOnExposure,
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
    effectedFamilyMembers.dispose();
    reportTextController.dispose();
    precautions.dispose();
    return super.close();
  }
}
