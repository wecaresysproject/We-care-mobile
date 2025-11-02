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
    await emitCountriesData();

    await emitDoctorNames();
  }

  void loadAnalysisDataForEditing(
      AnalysisDetailedData editingAnalysisDetailsData) {
    emit(
      state.copyWith(
        selectedDate: editingAnalysisDetailsData.testDate,
        // isTestPictureSelected:
        //     editingAnalysisDetailsData.imageBase64.isNotEmpty,
        // testReportUploadedUrl: editingAnalysisDetailsData.reportBase64,
        // testPictureUploadedUrl: editingAnalysisDetailsData.imageBase64,
        selectedCountryName: editingAnalysisDetailsData.country,
        selectedHospitalName: editingAnalysisDetailsData.hospital,
        selectedDoctorName: editingAnalysisDetailsData.doctor,
        selectedSymptomsForProcedure:
            editingAnalysisDetailsData.symptomsForProcedure,
        isTestGroupNameSelected: editingAnalysisDetailsData.groupName,
        selectedNoOftimesTestPerformed: editingAnalysisDetailsData.testNeedType,
        isEditMode: true,
        updatedTestId: editingAnalysisDetailsData.id,
        uploadedTestImages: editingAnalysisDetailsData.imageBase64,
        uploadedTestReports: editingAnalysisDetailsData.reportBase64,
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

  String? getSelectedChoiceAccordingToTestName(String testName) {
    for (var element in state.testTableRowsData) {
      if (element.testName == testName) {
        return element.selectedChoice;
      }
    }
    return null;
  }

  void updateTestDate(String? date) {
    emit(
      state.copyWith(
        selectedDate: date,
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

  void removeUploadedImage(String url) {
    final updated = List<String>.from(state.uploadedTestImages)..remove(url);

    emit(
      state.copyWith(
        uploadedTestImages: updated,
        message: "تم حذف الصورة",
      ),
    );
    validateRequiredFields();
  }

  void removeUploadedTestReport(String path) {
    final updated = List<String>.from(state.uploadedTestReports)..remove(path);
    emit(
      state.copyWith(
        uploadedTestReports: updated,
        message: "تم حذف التقرير",
      ),
    );
  }

  Future<void> uploadLaboratoryTestImagePicked({
    required String imagePath,
  }) async {
    // 1) Check limit
    if (state.uploadedTestImages.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          testImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }

    // 2) Emit loading state
    emit(
      state.copyWith(
        testImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );

    // 3) Call API
    final response = await _testAnalysisDataEntryRepo.uploadLaboratoryTestImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );

    // 4) Handle response
    response.when(
      success: (res) {
        // add URL to existing list
        final updatedImages = List<String>.from(state.uploadedTestImages)
          ..add(res.imageUrl);

        emit(
          state.copyWith(
            uploadedTestImages: updatedImages,
            message: res.message,
            testImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );

        validateRequiredFields();
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
    // 1) Check limit
    if (state.uploadedTestReports.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          testReportRequestStatus: UploadReportRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        testReportRequestStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response =
        await _testAnalysisDataEntryRepo.uploadLaboratoryReportImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final updatedTestReports = List<String>.from(state.uploadedTestReports)
          ..add(response.reportUrl);
        emit(
          state.copyWith(
            uploadedTestReports: updatedTestReports,
            message: response.message,
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
    log("xxx uploaded image length: ${state.uploadedTestImages.length} , uploaded picture urls: ${state.uploadedTestImages.map((e) => e).toList()}");
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
        testImages: state.uploadedTestImages,
        reportImages: state.uploadedTestReports,
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

  Future<void> submitEditsOnTest() async {
    emit(
      state.copyWith(
        testAnalysisDataEntryStatus: RequestStatus.loading,
      ),
    );
    //!because i pass all edited data to loadAnalysisDataForEditing method at begining of my cubit in case i have an model to edit
    final response = await _testAnalysisDataEntryRepo.editLaboratoryTestData(
      requestBodyModel: EditTestAnalysisDataEnteryRequestBodyModel(
        country: state.selectedCountryName!,
        testDate: state.selectedDate!,
        testImages: state.uploadedTestImages,
        reportImages: state.uploadedTestReports,
        hospital: state.selectedHospitalName!,
        doctor: state.selectedDoctorName!,
        symptomsForProcedure: state.selectedSymptomsForProcedure!,
        timesTestPerformed: state.selectedNoOftimesTestPerformed!,
      ),
      testId: state.updatedTestId,
      language: AppStrings.arabicLang,
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

  Future<void> emitDoctorNames() async {
    final response = await _testAnalysisDataEntryRepo.getAllDoctors(
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

  void validateRequiredFields() {
    if (state.selectedDate == null ||
        state.uploadedTestImages.isEmpty ||
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
