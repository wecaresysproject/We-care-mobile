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

  void updateSurgeryName(String? name) {
    emit(state.copyWith(surgeryNameSelection: name));
    validateRequiredFields();
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
    return super.close();
  }
}
