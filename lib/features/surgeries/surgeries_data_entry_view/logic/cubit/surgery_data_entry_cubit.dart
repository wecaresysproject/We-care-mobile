import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';
import 'package:we_care/features/surgeries/data/models/surgery_request_body_model.dart';
import 'package:we_care/features/surgeries/data/repos/surgeries_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'surgery_data_entry_state.dart';

class SurgeryDataEntryCubit extends Cubit<SurgeryDataEntryState> {
  SurgeryDataEntryCubit(this._surgeriesDataEntryRepo, this.sharedRepo)
      : super(
          SurgeryDataEntryState.initialState(),
        );
  final SurgeriesDataEntryRepo _surgeriesDataEntryRepo;
  final AppSharedRepo sharedRepo;

  final personalNotesController = TextEditingController();
  final suergeryDescriptionController = TextEditingController(); // وصف اضافي
  final postSurgeryInstructions = TextEditingController();
  final reportTextController = TextEditingController();

  /// Free-text technique, used only when the selected surgery has no
  /// predefined catalogue to pick from.
  final techniqueController = TextEditingController();

  /// Optional fields are persisted with a "no data" sentinel. It must never be
  /// hydrated back into an editable field, or the user sees it as something
  /// they typed and it gets written back verbatim.
  String? _withoutNoDataSentinel(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null ||
        trimmed.isEmpty ||
        trimmed == S.current.no_data_entered) {
      return null;
    }
    return trimmed;
  }

  Future<void> loadPastSurgeryDataForEditing(SurgeryModel pastSurgery) async {
    final savedTechnique = _withoutNoDataSentinel(pastSurgery.usedTechnique);

    emit(
      state.copyWith(
        surgeryDateSelection: pastSurgery.surgeryDate,
        surgeryBodyPartSelection: pastSurgery.surgeryRegion,
        selectedSubSurgery: pastSurgery.subSurgeryRegion,
        surgeryNameSelection: pastSurgery.surgeryName,
        selectedTechUsed: () => savedTechnique,
        // Straight to `loading`, never `initial`: a loaded record already has a
        // technique, and it must not sit hidden for the several sequential
        // requests below before resolution starts.
        techniqueResolution: TechniqueResolutionState.loading,
        surgeryPurpose: () => pastSurgery.purpose,
        reportsImageUploadedUrls: pastSurgery.medicalReportImage,
        selectedSurgeryStatus: pastSurgery.surgeryStatus,
        selectedHospitalCenter: pastSurgery.hospitalCenter,
        internistName: pastSurgery.anesthesiologistName,
        selectedCountryName: pastSurgery.country,
        surgeonName: pastSurgery.surgeonName,
        isEditMode: true,
        updatedSurgeryId: pastSurgery.id,
      ),
    );
    personalNotesController.text = pastSurgery.additionalNotes;
    suergeryDescriptionController.text = pastSurgery.surgeryDescription;
    reportTextController.text = pastSurgery.writtenReport ?? "";
    techniqueController.text = savedTechnique ?? "";

    postSurgeryInstructions.text = pastSurgery.postSurgeryInstructions;

    validateRequiredFields();
    await intialRequestsForDataEntry();

    // The saved record already carries region + sub-region + name, which is
    // everything the lookup needs. Without this the field would resolve to
    // "no catalogue" for *every* edited record and silently downgrade a
    // predefined surgery's technique to optional free text.
    await emitGetAllTechUsed();
  }

  /// Update Field Values
  void updateSurgeryDate(String? date) {
    emit(state.copyWith(surgeryDateSelection: date));
    validateRequiredFields();
  }

  void updateSelectedHospitalCenter(String? selectedHospital) {
    emit(state.copyWith(selectedHospitalCenter: selectedHospital));
  }

  void updateSelectedInternist(String? selectedInternist) {
    emit(state.copyWith(internistName: selectedInternist));
  }

  void updateSelectedSurgeonName(String? surgeonName) {
    emit(state.copyWith(surgeonName: surgeonName));
  }

  Future<void> emitDoctorNames() async {
    final response = await sharedRepo.getAllDoctors(
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

  void updateSelectedCountry(String? selectedCountry) {
    emit(state.copyWith(selectedCountryName: selectedCountry));
  }

  void updateSurgeryBodyPart(String? bodyPart) {
    emit(state.copyWith(surgeryBodyPartSelection: bodyPart));
    validateRequiredFields();
    emitGetAllSubSurgeriesRegions(selectedRegion: bodyPart!);
  }

  Future<void> updateSurgeryName(String? name) async {
    // Everything downstream of the surgery name — the technique catalogue, the
    // chosen technique, the derived purpose — belongs to the *previous*
    // surgery and must not survive onto this one.
    emit(
      state.copyWith(
        surgeryNameSelection: name,
        allTechUsed: const [],
        selectedTechUsed: () => null,
        surgeryPurpose: () => null,
        techniqueOptionsLoadFailed: false,
      ),
    );
    techniqueController.clear();
    validateRequiredFields();
    await emitGetAllTechUsed();
  }

  void updateSurgeryStatus(String? bodyPart) {
    emit(state.copyWith(selectedSurgeryStatus: bodyPart));
  }

  Future<void> updateSelectedTechUsed(String? val) async {
    emit(state.copyWith(selectedTechUsed: () => val));
    await emitSurgeryPurpose();
    validateRequiredFields();
  }

  Future<void> updateSelectedSubSurgery(String? value) async {
    emit(state.copyWith(selectedSubSurgery: value));
    await emitSurgeryNamesBasedOnRegion(
      region: state.surgeryBodyPartSelection!,
      subRegion: value!,
    );
    // A name picked under the old sub-region resolves against a different
    // catalogue now, so re-resolve rather than leave the field asserting a
    // requirement that no longer holds.
    if (state.surgeryNameSelection != null) {
      await emitGetAllTechUsed();
    }
    validateRequiredFields();
  }

  /// Re-runs the lookup after a failure, from the retry affordance on the
  /// free-text fallback.
  Future<void> retryTechniqueResolution() async {
    await emitGetAllTechUsed();
  }

  Future<void> intialRequestsForDataEntry() async {
    await emitModuleGuidanceData();
    await emitGetAllSurgeriesRegions();
    await emitCountriesData();
    await emitDoctorNames();
    await emitHospitalNames();
  }

  Future<void> emitModuleGuidanceData() async {
    final response = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.surgeriesDataEntry.name,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            moduleGuidanceData: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  void removeUploadedReport(String url) {
    final updated = List<String>.from(state.reportsImageUploadedUrls)
      ..remove(url);

    emit(
      state.copyWith(
        reportsImageUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadReportImagePicked({required String imagePath}) async {
    // 1) Check limit
    if (state.reportsImageUploadedUrls.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          surgeryUploadReportStatus: UploadReportRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        surgeryUploadReportStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _surgeriesDataEntryRepo.uploadReportImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final updatedReports = List<String>.from(state.reportsImageUploadedUrls)
          ..add(response.reportUrl);
        emit(
          state.copyWith(
            message: response.message,
            reportsImageUploadedUrls: updatedReports,
            surgeryUploadReportStatus: UploadReportRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            surgeryUploadReportStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitGetAllTechUsed() async {
    final region = state.surgeryBodyPartSelection;
    final subRegion = state.selectedSubSurgery;
    final surgeryName = state.surgeryNameSelection;

    // A custom name can be typed before the region chain is complete, so these
    // are genuinely nullable here — there is nothing to resolve against yet.
    if (region == null || subRegion == null || surgeryName == null) {
      emit(
        state.copyWith(
          allTechUsed: const [],
          techniqueResolution: TechniqueResolutionState.initial,
          techniqueOptionsLoadFailed: false,
        ),
      );
      validateRequiredFields();
      return;
    }

    emit(
      state.copyWith(
        techniqueResolution: TechniqueResolutionState.loading,
        techniqueOptionsLoadFailed: false,
      ),
    );
    validateRequiredFields();

    final response = await _surgeriesDataEntryRepo.getAllTechUsed(
      language: AppStrings.arabicLang,
      region: region,
      subRegion: subRegion,
      surgeryName: surgeryName,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allTechUsed: response,
            techniqueResolution: response.isEmpty
                ? TechniqueResolutionState.noPredefinedOptions
                : TechniqueResolutionState.hasPredefinedOptions,
            techniqueOptionsLoadFailed: false,
          ),
        );
      },
      failure: (error) {
        // Collapse failure into the manual path: the user is never blocked on
        // a lookup they can't control. The flag only drives a retry hint.
        emit(
          state.copyWith(
            allTechUsed: const [],
            techniqueResolution: TechniqueResolutionState.noPredefinedOptions,
            techniqueOptionsLoadFailed: true,
            message: error.errors.first,
          ),
        );
      },
    );
    validateRequiredFields();
  }

  Future<void> submitUpdatedSurgery(S locale) async {
    emit(
      state.copyWith(
        surgeriesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _surgeriesDataEntryRepo.updateSurgeryDocumentById(
      langauge: AppStrings.arabicLang,
      requestBody: SurgeryRequestBodyModel(
        writtenReport: reportTextController.text,
        surgeryDate: state.surgeryDateSelection!,
        surgeryRegion: state.surgeryBodyPartSelection!,
        subSurgeryRegion: state.selectedSubSurgery!,
        surgeryName: state.surgeryNameSelection!,
        usedTechnique: _usedTechniqueForSubmission(locale),
        additionalNotes: personalNotesController.text,
        surgeryDescription: suergeryDescriptionController.text,
        postSurgeryInstructions: postSurgeryInstructions.text,
        surgeryStatus: state.selectedSurgeryStatus!,
        hospitalCenter: state.selectedHospitalCenter!,
        anesthesiologistName: state.internistName!,
        country: state.selectedCountryName!,
        surgeonName: state.surgeonName!,
        medicalReportImage: state.reportsImageUploadedUrls,
      ),
      id: state.updatedSurgeryId,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            surgeriesDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            surgeriesDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitHospitalNames() async {
    final response = await sharedRepo.getHospitalNames(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            hospitals: response,
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
    final response = await _surgeriesDataEntryRepo.getAllSubSurgeriesRegions(
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
    final response = await _surgeriesDataEntryRepo.getSurgeryNamesBasedOnRegion(
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
    final response = await _surgeriesDataEntryRepo.getAllSurgeriesRegions(
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
    final response = await sharedRepo.getCountriesData(
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

  Future<void> emitSurgeryPurpose() async {
    // The purpose is only derivable for a catalogued surgery + technique pair.
    // Anything else has no purpose to fetch, and leaving the previous one in
    // place would attribute it to the wrong operation.
    if (!state.isTechniqueRequired || state.selectedTechUsed == null) {
      emit(state.copyWith(surgeryPurpose: () => null));
      return;
    }

    final response = await _surgeriesDataEntryRepo.getSurgeryPurpose(
      language: AppStrings.arabicLang,
      region: state.surgeryBodyPartSelection!,
      subRegion: state.selectedSubSurgery!,
      surgeryName: state.surgeryNameSelection!,
      techUsed: state.selectedTechUsed!,
    );
    AppLogger.info(
      "emitSurgeryPurpose called after updateSelectedTechUsed and values of state are: ${state.surgeryBodyPartSelection}, ${state.selectedSubSurgery}, ${state.surgeryNameSelection}, ${state.selectedTechUsed}",
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            surgeryPurpose: () => response,
          ),
        );
        AppLogger.info("xxx: surgeryPurpose: $response");
      },
      failure: (error) {
        emit(
          state.copyWith(
            surgeryPurpose: () => null,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    // The technique is only required once we know a catalogue exists for it.
    // While resolution is still pending we can't know either way, so the form
    // stays blocked rather than guessing.
    final isTechniqueSatisfied = state.isTechniqueResolved &&
        (!state.isTechniqueRequired || state.selectedTechUsed != null);

    final isValid = state.surgeryDateSelection != null &&
        state.surgeryNameSelection != null &&
        state.surgeryBodyPartSelection != null &&
        state.selectedSubSurgery != null &&
        isTechniqueSatisfied;

    emit(
      state.copyWith(
        isFormValidated: isValid,
      ),
    );
  }

  /// Where the submitted technique comes from depends on which control the
  /// user was actually given.
  String _usedTechniqueForSubmission(S locale) {
    if (state.isTechniqueRequired) {
      return state.selectedTechUsed ?? locale.no_data_entered;
    }
    final typed = techniqueController.text.trim();
    return typed.isEmpty ? locale.no_data_entered : typed;
  }

  Future<void> postModuleData(S locale) async {
    final response = await _surgeriesDataEntryRepo.postModuleData(
      language: AppStrings.arabicLang,
      requestBody: SurgeryRequestBodyModel(
        writtenReport: reportTextController.text.isEmpty
            ? locale.no_data_entered
            : reportTextController.text,
        surgeryDate: state.surgeryDateSelection!,
        surgeryName: state.surgeryNameSelection!,
        surgeryRegion: state.surgeryBodyPartSelection!,
        subSurgeryRegion: state.selectedSubSurgery!,
        usedTechnique: _usedTechniqueForSubmission(locale),
        surgeryDescription: suergeryDescriptionController.text.isEmpty
            ? locale.no_data_entered
            : suergeryDescriptionController.text,
        medicalReportImage: state.reportsImageUploadedUrls,
        surgeryStatus: state.selectedSurgeryStatus ?? locale.no_data_entered,
        hospitalCenter: state.selectedHospitalCenter ?? locale.no_data_entered,
        surgeonName: state.surgeonName ?? locale.no_data_entered,
        anesthesiologistName: state.internistName ?? locale.no_data_entered,
        postSurgeryInstructions: postSurgeryInstructions.text.isEmpty
            ? locale.no_data_entered
            : postSurgeryInstructions.text,
        country: state.selectedCountryName ?? locale.no_data_entered,
        additionalNotes: personalNotesController.text.isEmpty
            ? locale.no_data_entered
            : personalNotesController.text,
      ),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response,
            surgeriesDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            surgeriesDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    suergeryDescriptionController.dispose();
    postSurgeryInstructions.dispose();
    reportTextController.dispose();
    techniqueController.dispose();
    return super.close();
  }
}
