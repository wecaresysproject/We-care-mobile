import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_analysis_request_body_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'test_analysis_data_entry_state.dart';

class TestAnalysisDataEntryCubit extends Cubit<TestAnalysisDataEntryState> {
  TestAnalysisDataEntryCubit(this._testAnalysisDataEntryRepo, this.sharedRepo)
      : super(
          TestAnalysisDataEntryState.initial(),
        );

  final TestAnalysisDataEntryRepo _testAnalysisDataEntryRepo;
  final AppSharedRepo sharedRepo;

  final TextEditingController reportTextController = TextEditingController();

  Future<void> intialRequestsForTestAnalysisDataEntry() async {
    await Future.wait([
      emitListOfTestAnnotations(
        testType: UserTypes.patient.name.firstLetterToUpperCase,
        language: AppStrings.arabicLang,
      ),
      emitListOfTestGroupNames(
        language: AppStrings.arabicLang,
        userType: UserTypes.patient.name.firstLetterToUpperCase,
      ),
      emitListOfTestNames(
        language: AppStrings.arabicLang,
        userType: UserTypes.patient.name.firstLetterToUpperCase,
      ),
      emitCountriesData(),
      emitDoctorNames(),
      emitLabCenters(),
      emitHospitalNames(),
    ]);
  }

  void loadAnalysisDataForEditing(
      AnalysisDetailedData editingAnalysisDetailsData) {
    safeEmit(
      state.copyWith(
        selectedDate: editingAnalysisDetailsData.testDate,
        selectedCountryName: editingAnalysisDetailsData.country,
        selectedHospitalName: editingAnalysisDetailsData.hospital,
        selectedDoctorName: editingAnalysisDetailsData.doctor,
        symptomsRequiringIntervention:
            editingAnalysisDetailsData.symptomsRequiringIntervention,
        isTestGroupNameSelected: editingAnalysisDetailsData.groupName,
        selectedNoOftimesTestPerformed: editingAnalysisDetailsData.testNeedType,
        isEditMode: true,
        updatedTestId: editingAnalysisDetailsData.id,
        uploadedTestImages: editingAnalysisDetailsData.imageBase64,
        uploadedTestReports: editingAnalysisDetailsData.reportBase64,
        selectedLabCenter: editingAnalysisDetailsData.radiologyCenter,
      ),
    );
    reportTextController.text = editingAnalysisDetailsData.writtenReport ?? "";
    validateRequiredFields();
    intialRequestsForTestAnalysisDataEntry();
  }

  void updateTimesTestPerformed(String? timesTestPerformed) {
    safeEmit(
      state.copyWith(
        selectedNoOftimesTestPerformed: timesTestPerformed,
      ),
    );
  }

  void updateSelectedLabCenter(String? val) {
    safeEmit(
      state.copyWith(
        selectedLabCenter: val,
      ),
    );
  }

  void updateSelectedHospital(String? hospitalName) {
    safeEmit(
      state.copyWith(
        selectedHospitalName: hospitalName,
      ),
    );
  }

  void updateSelectedDoctorName(String? doctorName) {
    safeEmit(
      state.copyWith(
        selectedDoctorName: doctorName,
      ),
    );
  }

  void updateTestTableRowsData(List<TableRowReponseModel> tableRows) {
    // فلترة العناصر اللي فيها بيانات كاملة فقط
    final validRows = tableRows.where((row) {
      final validRow =
          (row.testWrittenPercent != null || row.selectedChoice != null);
      return validRow;
    }).toList();

    // إرسال فقط العناصر الصالحة
    safeEmit(
      state.copyWith(
        enteredTableRows: validRows,
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
    safeEmit(
      state.copyWith(
        selectedDate: date,
      ),
    );
    validateRequiredFields();
  }

  Future<void> updateTestName(String? type) async {
    safeEmit(
      state.copyWith(
        isTestNameSelected: type,
      ),
    );
    await getTableDetails();
    validateRequiredFields();
  }

  Future<void> updateGroupNameSelection(String? selectedGroupName) async {
    safeEmit(
      state.copyWith(
        isTestGroupNameSelected: selectedGroupName,
      ),
    );
    await getTableDetails();
    validateRequiredFields();
  }

  void updateSelectedCountry(String? selectedCountry) {
    safeEmit(
      state.copyWith(
        selectedCountryName: selectedCountry,
      ),
    );
  }

  void removeUploadedImage(String url) {
    final updated = List<String>.from(state.uploadedTestImages)..remove(url);

    safeEmit(
      state.copyWith(
        uploadedTestImages: updated,
        message: "تم حذف الصورة",
      ),
    );
    validateRequiredFields();
  }

  void removeUploadedTestReport(String path) {
    final updated = List<String>.from(state.uploadedTestReports)..remove(path);
    safeEmit(
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
      safeEmit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          testImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }

    // 2) safeEmit loading state
    safeEmit(
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

        safeEmit(
          state.copyWith(
            uploadedTestImages: updatedImages,
            message: res.message,
            testImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );

        validateRequiredFields();
      },
      failure: (error) {
        safeEmit(
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
        safeEmit(
          state.copyWith(
            testCodes: testCodes,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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
        safeEmit(
          state.copyWith(
            testGroupNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  void updateSymptomsRequiringIntervention(String issue) {
    if (issue.isEmpty) return;

    List<String> symptoms = List.from(state.symptomsRequiringIntervention);

    // موجود؟ شيله .. مش موجود؟ ضيفه  (toggle)
    if (symptoms.contains(issue)) {
      symptoms.remove(issue);
    } else {
      symptoms.add(issue);
    }

    emit(state.copyWith(symptomsRequiringIntervention: symptoms));
  }

  void removeSymptomRequiringIntervention(String issue) {
    List<String> symptoms = List.from(state.symptomsRequiringIntervention);
    symptoms.remove(issue);
    emit(state.copyWith(symptomsRequiringIntervention: symptoms));
  }

  Future<void> emitListOfTestNames(
      {required String language, required String userType}) async {
    final response = await _testAnalysisDataEntryRepo.getListOfTestNames(
      language: language,
      userType: userType,
    );
    response.when(
      success: (listOfTestNames) {
        safeEmit(
          state.copyWith(
            testNames: listOfTestNames,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(),
        );
      },
    );
  }

  Future<void> uploadLaboratoryTestReportPicked(
      {required String imagePath}) async {
    // 1) Check limit
    if (state.uploadedTestReports.length >= 8) {
      safeEmit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          testReportRequestStatus: UploadReportRequestStatus.failure,
        ),
      );
      return;
    }
    safeEmit(
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
        safeEmit(
          state.copyWith(
            uploadedTestReports: updatedTestReports,
            message: response.message,
            testReportRequestStatus: UploadReportRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            testReportRequestStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> updateTestCodeSelection(String? testCode) async {
    safeEmit(
      state.copyWith(
        isTestCodeSelected: testCode,
      ),
    );
    await getTableDetails();
    validateRequiredFields();
  }

  Future<void> emitCountriesData() async {
    final response = await sharedRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            countriesNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitLabCenters() async {
    final response = await sharedRepo.getLabCenters(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            labCenters: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
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
        safeEmit(
          state.copyWith(
            hospitalNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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
        safeEmit(
          state.copyWith(
            testTableRowsData: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> postLaboratoryTestDataEntrered(S localozation) async {
    log("xxx uploaded image length: ${state.uploadedTestImages.length} , uploaded picture urls: ${state.uploadedTestImages.map((e) => e).toList()}");
    safeEmit(
      state.copyWith(
        testAnalysisDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _testAnalysisDataEntryRepo.postLaboratoryTestDataEntrered(
      testAnalysisRequestBodyModel: TestAnalysisDataEnteryRequestBodyModel(
        radiologyCenter:
            state.selectedLabCenter ?? localozation.no_data_entered,
        country: state.selectedCountryName ?? localozation.no_data_entered,
        testDate: state.selectedDate!,
        testTableEnteredResults: state.enteredTableRows,
        testImages: state.uploadedTestImages,
        reportImages: state.uploadedTestReports,
        hospital: state.selectedHospitalName ?? localozation.no_data_entered,
        doctor: state.selectedDoctorName ?? localozation.no_data_entered,
        symptomsRequiringIntervention: state.symptomsRequiringIntervention,
        timesTestPerformed: state.selectedNoOftimesTestPerformed ??
            localozation.no_data_entered,
        writtenReport: reportTextController.text.isEmpty
            ? localozation.no_data_entered
            : reportTextController.text,
      ),
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            testAnalysisDataEntryStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            testAnalysisDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  /// this method is used to safeEmit state only if cubit is not closed
  void safeEmit(TestAnalysisDataEntryState newState) {
    if (!isClosed) {
      emit(newState);
    } else {
      log("⚠️ Tried to emit after cubit was closed. Ignored safely.");
    }
  }

  Future<void> submitEditsOnTest() async {
    safeEmit(
      state.copyWith(
        testAnalysisDataEntryStatus: RequestStatus.loading,
      ),
    );
    //!because i pass all edited data to loadAnalysisDataForEditing method at begining of my cubit in case i have an model to edit
    final response = await _testAnalysisDataEntryRepo.editLaboratoryTestData(
      requestBodyModel: EditTestAnalysisDataEnteryRequestBodyModel(
        radiologyCenter: state.selectedLabCenter!,
        country: state.selectedCountryName!,
        testDate: state.selectedDate!,
        testImages: state.uploadedTestImages,
        reportImages: state.uploadedTestReports,
        hospital: state.selectedHospitalName!,
        doctor: state.selectedDoctorName!,
        symptomsRequiringIntervention: state.symptomsRequiringIntervention,
        timesTestPerformed: state.selectedNoOftimesTestPerformed!,
      ),
      testId: state.updatedTestId,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            testAnalysisDataEntryStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            testAnalysisDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitDoctorNames() async {
    final response = await sharedRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            doctorNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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
      safeEmit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      safeEmit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    reportTextController.dispose();
    return super.close();
  }
}
