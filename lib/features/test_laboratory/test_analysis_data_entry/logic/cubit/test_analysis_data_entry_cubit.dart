import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_data_entry_repo.dart';

part 'test_analysis_data_entry_state.dart';

class TestAnalysisDataEntryCubit extends Cubit<TestAnalysisDataEntryState> {
  TestAnalysisDataEntryCubit(this._testAnalysisDataEntryRepo)
      : super(
          TestAnalysisDataEntryState.initial(),
        );

  final TestAnalysisDataEntryRepo _testAnalysisDataEntryRepo;
  Future<void> intialRequestsForTestAnalysisDataEntry() async {
    await emitCountriesData();
    await emitListOfTestAnnotations(
      testType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );
    await emitListOfTestGroupNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    await emitListOfTestNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
  }

  void updateTestDate(String? date) {
    emit(
      state.copyWith(
        isDateSelected: date,
      ),
    );
    validateRequiredFields();
  }

  void updateTestPicture(bool? isImagePicked) {
    emit(
      state.copyWith(
        isTestPictureSelected: isImagePicked,
      ),
    );
    validateRequiredFields();
  }

  void updateTestName(String? type) {
    emit(
      state.copyWith(
        isTestNameSelected: type,
      ),
    );
    validateRequiredFields();
  }

  void updateGroupNameSelection(String? selectedGroupName) {
    emit(
      state.copyWith(
        isTestGroupNameSelected: selectedGroupName,
      ),
    );
    validateRequiredFields();
  }

  void updateSelectedCountry(String? selectedCountry) {
    emit(
      state.copyWith(
        selectedCountryName: selectedCountry,
      ),
    );
  }

  Future<void> uploadLaboratoryTestImagePicked(
      {required String imagePath}) async {
    final response = await _testAnalysisDataEntryRepo.uploadLaboratoryTestImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            testPictureUploadedUrl: response.imageUrl,
            testImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            testImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitListOfTestAnnotations(
      {required String language, required String testType}) async {
    final response = await _testAnalysisDataEntryRepo.getListOFTestAnnotations(
      language: language,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (testCodes) {
        emit(
          state.copyWith(
            testCodes: testCodes,
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

  Future<void> emitListOfTestGroupNames(
      {required String language, required String userType}) async {
    final response = await _testAnalysisDataEntryRepo.getListOfTestGroupNames(
      language: language,
      userType: userType,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            testGroupNames: response,
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

  Future<void> emitListOfTestNames(
      {required String language, required String userType}) async {
    final response = await _testAnalysisDataEntryRepo.getListOfTestNames(
      language: language,
      userType: userType,
    );
    response.when(
      success: (listOfTestNames) {
        emit(
          state.copyWith(
            testNames: listOfTestNames,
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

  Future<void> uploadLaboratoryTestReportPicked(
      {required String imagePath}) async {
    final response =
        await _testAnalysisDataEntryRepo.uploadLaboratoryReportImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            testPictureUploadedUrl: response.reportUrl,
            testReportRequestStatus: UploadReportRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            testReportRequestStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  void updateTestCodeSelection(String? testCode) {
    emit(
      state.copyWith(
        isTestCodeSelected: testCode,
      ),
    );
    validateRequiredFields();
  }

  Future<void> emitCountriesData() async {
    final response = await _testAnalysisDataEntryRepo.getCountriesData(
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

  void validateRequiredFields() {
    if (state.isDateSelected == null ||
        state.isTestPictureSelected == null ||
        state.isTestPictureSelected == false ||
        (state.isTestNameSelected == null &&
            state.isTestCodeSelected == null &&
            state.isTestGroupNameSelected == null)) {
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
}
