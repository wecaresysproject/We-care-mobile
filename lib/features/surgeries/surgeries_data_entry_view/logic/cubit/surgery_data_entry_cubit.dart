import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/surgeries/data/repos/surgeries_data_entry_repo.dart';

part 'surgery_data_entry_state.dart';

class SurgeryDataEntryCubit extends Cubit<SurgeryDataEntryState> {
  SurgeryDataEntryCubit(this._surgeriesDataEntryRepo)
      : super(
          SurgeryDataEntryState.initialState(),
        );
  final SurgeriesDataEntryRepo _surgeriesDataEntryRepo;
  final personalNotesController = TextEditingController();
  final suergeryDescriptionController =
      TextEditingController(); // توصيف العملليه

  /// Update Field Values
  void updateSurgeryDate(String? date) {
    emit(state.copyWith(surgeryDateSelection: date));
    validateRequiredFields();
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
    emit(state.copyWith(surgeryNameSelection: name));
    validateRequiredFields();
    await emitGetAllTechUsed();
  }

  Future<void> updateSelectedTechUsed(String? val) async {
    emit(state.copyWith(selectedTechUsed: val));
    await emitSurgeryPurpose();
  }

  Future<void> updateSelectedSubSurgery(String? value) async {
    emit(state.copyWith(selectedSubSurgery: value));
    await emitSurgeryNamesBasedOnRegion(
      region: state.surgeryBodyPartSelection!,
      subRegion: value!,
    );
  }

  Future<void> intialRequestsForDataEntry() async {
    await emitGetAllSurgeriesRegions();
    await emitCountriesData();
    await emitGetSurgeryStatus();
  }

  Future<void> uploadReportImagePicked({required String imagePath}) async {
    final response = await _surgeriesDataEntryRepo.uploadReportImage(
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
    final response = await _surgeriesDataEntryRepo.getAllTechUsed(
      language: AppStrings.arabicLang,
      region: state.surgeryBodyPartSelection!,
      subRegion: state.selectedSubSurgery!,
      surgeryName: state.surgeryNameSelection!,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allTechUsed: response,
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

  Future<void> emitGetSurgeryStatus() async {
    final response = await _surgeriesDataEntryRepo.getSurgeryStatus(
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
    final response = await _surgeriesDataEntryRepo.getCountriesData(
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

  Future<void> emitSurgeryPurpose() async {
    final response = await _surgeriesDataEntryRepo.getSurgeryPurpose(
      language: AppStrings.arabicLang,
      region: state.surgeryBodyPartSelection!,
      subRegion: state.selectedSubSurgery!,
      surgeryName: state.surgeryNameSelection!,
      techUsed: state.selectedTechUsed!,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            surgeryPurposes: response,
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
    if (state.surgeryDateSelection == null ||
        state.surgeryNameSelection == null ||
        state.surgeryBodyPartSelection == null) {
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
    personalNotesController.dispose();
    suergeryDescriptionController.dispose();
    return super.close();
  }
}
