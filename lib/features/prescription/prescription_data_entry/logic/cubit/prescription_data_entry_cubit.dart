import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/prescription/data/repos/prescription_data_entry_repo.dart';

part 'prescription_data_entry_state.dart';

class PrescriptionDataEntryCubit extends Cubit<PrescriptionDataEntryState> {
  PrescriptionDataEntryCubit(this._prescriptionDataEntryRepo)
      : super(
          PrescriptionDataEntryState.initialState(),
        );
  final PrescriptionDataEntryRepo _prescriptionDataEntryRepo;
  final personalNotesController = TextEditingController();
  final symptomsAccompanyingComplaintController =
      TextEditingController(); // الاعراض المصاحبة للشكوى

  final formKey = GlobalKey<FormState>();

  /// Update Field Values
  void updatePrescriptionDate(String? date) {
    emit(state.copyWith(preceriptionDateSelection: date));
    validateRequiredFields();
  }

  void updateDoctorName(String? doctorName) {
    emit(state.copyWith(doctorNameSelection: doctorName));
    validateRequiredFields();
  }

  void updateDoctorSpeciality(String? speciality) {
    emit(state.copyWith(doctorSpecialitySelection: speciality));
    validateRequiredFields();
  }

  void updateSelectedCountry(String? selectedCountry) {
    emit(
      state.copyWith(
        selectedCountryName: selectedCountry,
      ),
    );
  }

  void updateSelectedCityName(String? selectedCity) {
    emit(
      state.copyWith(
        selectedCityName: selectedCity,
      ),
    );
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForPrescriptionDataEntry() async {
    await emitCountriesData();
  }

  Future<void> emitCitiesData() async {
    final response =
        await _prescriptionDataEntryRepo.getCitiesBasedOnCountryName(
      language: AppStrings.arabicLang,
      cityName: state.selectedCountryName ?? "egypt",
    );

    response.when(
      success: (citiesList) {
        emit(
          state.copyWith(
            citiesNames: citiesList,
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

  Future<void> uploadPrescriptionImagePicked(
      {required String imagePath}) async {
    final response = await _prescriptionDataEntryRepo.uploadPrescriptionImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            prescriptionPictureUploadedUrl: response.imageUrl,
            prescriptionImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            prescriptionImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitCountriesData() async {
    final response = await _prescriptionDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response.map((e) => e.name).toList(),
          ),
        );
        emitCitiesData();
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

  void updatePrescriptionPicture(bool? isImagePicked) {
    emit(state.copyWith(isPrescriptionPictureSelected: isImagePicked));
    validateRequiredFields();
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.preceriptionDateSelection == null ||
        state.doctorNameSelection == null ||
        state.doctorSpecialitySelection == null ||
        state.isPrescriptionPictureSelected == null ||
        state.isPrescriptionPictureSelected == false) {
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
    symptomsAccompanyingComplaintController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
