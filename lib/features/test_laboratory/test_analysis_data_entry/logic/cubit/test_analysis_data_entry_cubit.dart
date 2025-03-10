import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_analysis_request_body_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

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

  void loadAnalysisDataForEditing(
      AnalysisDetailedData editingAnalysisDetailsData) {
    emit(
      state.copyWith(
        selectedDate: editingAnalysisDetailsData.testDate,
        isTestPictureSelected:
            editingAnalysisDetailsData.imageBase64.isNotEmpty,
        testReportUploadedUrl: editingAnalysisDetailsData.reportBase64,
        selectedCountryName: editingAnalysisDetailsData.country,
        selectedHospitalName: editingAnalysisDetailsData.hospital,
        selectedDoctorName: editingAnalysisDetailsData.doctor,
        selectedSymptomsForProcedure:
            editingAnalysisDetailsData.symptomsForProcedure,
        isTestGroupNameSelected: editingAnalysisDetailsData.groupName,
        selectedNoOftimesTestPerformed: editingAnalysisDetailsData.testNeedType,
        isEditMode: true,
      ),
    );
    validateRequiredFields();
    intialRequestsForTestAnalysisDataEntry();
  }

  void updateTimesTestPerformed(String? timesTestPerformed) {
    emit(
      state.copyWith(
        selectedNoOftimesTestPerformed: timesTestPerformed,
      ),
    );
  }

  void updateSelectedSymptom(String? newSymptoms) {
    emit(
      state.copyWith(
        selectedSymptomsForProcedure: newSymptoms,
      ),
    );
  }

  void updateSelectedHospital(String? hospitalName) {
    emit(
      state.copyWith(
        selectedHospitalName: hospitalName,
      ),
    );
  }

  void updateSelectedDoctorName(String? doctorName) {
    emit(
      state.copyWith(
        selectedDoctorName: doctorName,
      ),
    );
  }

  void updateTestTableRowsData(List<TableRowReponseModel> tableRows) {
    for (var element in tableRows) {
      log("xxx: sent table rows : ${element.testName} ${element.testWrittenPercent}");
    }
    emit(
      state.copyWith(
        enteredTableRows: tableRows,
      ),
    );
  }

  void updateTestDate(String? date) {
    emit(
      state.copyWith(
        selectedDate: date,
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

  Future<void> updateTestName(String? type) async {
    emit(
      state.copyWith(
        isTestNameSelected: type,
      ),
    );
    await getTableDetails();
    validateRequiredFields();
  }

  Future<void> updateGroupNameSelection(String? selectedGroupName) async {
    emit(
      state.copyWith(
        isTestGroupNameSelected: selectedGroupName,
      ),
    );
    await getTableDetails();
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

  Future<void> updateTestCodeSelection(String? testCode) async {
    emit(
      state.copyWith(
        isTestCodeSelected: testCode,
      ),
    );
    await getTableDetails();
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

  Future<void> getTableDetails() async {
    final response = await _testAnalysisDataEntryRepo.getTableDetails(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      codeQuery: state.isTestCodeSelected,
      groupNameQuery: state.isTestGroupNameSelected,
      testNameQuery: state.isTestNameSelected,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            testTableRowsData: response,
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

  Future<void> postLaboratoryTestDataEntrered(S localozation) async {
    emit(
      state.copyWith(
        testAnalysisDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _testAnalysisDataEntryRepo.postLaboratoryTestDataEntrered(
      testAnalysisRequestBodyModel: TestAnalysisDataEnteryRequestBodyModel(
        country: state.selectedCountryName ?? localozation.no_data_entered,
        testDate: state.selectedDate!,
        testTableEnteredResults: state.enteredTableRows,
        testImage: state.testPictureUploadedUrl,
        reportImage: state.testPictureUploadedUrl,
        hospital: state.selectedHospitalName ?? localozation.no_data_entered,
        doctor: state.selectedDoctorName ?? localozation.no_data_entered,
        symptomsForProcedure:
            state.selectedSymptomsForProcedure ?? localozation.no_data_entered,
        timesTestPerformed: state.selectedNoOftimesTestPerformed ??
            localozation.no_data_entered,
      ),
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            testAnalysisDataEntryStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            testAnalysisDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  void validateRequiredFields() {
    if (state.selectedDate == null ||
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
