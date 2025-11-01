part of 'test_analysis_data_entry_cubit.dart';

@immutable
class TestAnalysisDataEntryState extends Equatable {
  final RequestStatus testAnalysisDataEntryStatus;

  final String? selectedDate;
  final bool? isTestPictureSelected;
  final String? isTestNameSelected;
  final String? isTestGroupNameSelected;
  final String? isTestCodeSelected;
  final bool isFormValidated;
  final List<String> countriesNames;
  final List<String> doctorNames;
  final String? selectedCountryName;
  final String? selectedHospitalName;
  final String? selectedDoctorName;
  final String? selectedSymptomsForProcedure;
  final String? selectedNoOftimesTestPerformed;
  final bool isEditMode;
  final String updatedTestId;

  final UploadImageRequestStatus testImageRequestStatus;
  final UploadReportRequestStatus testReportRequestStatus;
  final List<String> uploadedTestImages; // URLs returned from API
  final List<String> uploadedTestReports;

  final String message; // error or success message
  final String? selectedTestAnnotation;

  final List<String> testCodes;
  final List<String> testGroupNames;
  final List<String> testNames;
  final List<TableRowReponseModel> testTableRowsData;
  final List<TableRowReponseModel> enteredTableRows;

  const TestAnalysisDataEntryState({
    this.testAnalysisDataEntryStatus = RequestStatus.initial,
    this.countriesNames = const [],
    this.selectedDate,
    this.isFormValidated = false,
    this.isEditMode = false,
    this.isTestPictureSelected,
    this.isTestNameSelected,
    this.isTestGroupNameSelected,
    this.selectedCountryName,
    this.selectedHospitalName,
    this.selectedDoctorName,
    this.selectedSymptomsForProcedure,
    this.selectedNoOftimesTestPerformed,
    this.isTestCodeSelected,
    this.message = '',
    this.testImageRequestStatus = UploadImageRequestStatus.initial,
    this.testReportRequestStatus = UploadReportRequestStatus.initial,
    this.uploadedTestImages = const [],
    this.uploadedTestReports = const [],
    this.testCodes = const [],
    this.testGroupNames = const [],
    this.testNames = const [],
    this.testTableRowsData = const [],
    this.enteredTableRows = const [],
    this.selectedTestAnnotation,
    this.updatedTestId = '',
    this.doctorNames = const [],
  });
  const TestAnalysisDataEntryState.initial()
      : this(
          selectedDate: null,
          testAnalysisDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          isTestPictureSelected: null,
          isTestNameSelected: null,
          isTestGroupNameSelected: null,
          isTestCodeSelected: null,
          selectedCountryName: null,
          selectedHospitalName: null,
          selectedDoctorName: null,
          selectedSymptomsForProcedure: null,
          selectedNoOftimesTestPerformed: null,
          message: '',
          testImageRequestStatus: UploadImageRequestStatus.initial,
          testReportRequestStatus: UploadReportRequestStatus.initial,
          isEditMode: false,
          updatedTestId: '',
          uploadedTestImages: const [],
          countriesNames: const [],
          testCodes: const [],
          testGroupNames: const [],
          testNames: const [],
          testTableRowsData: const [],
          enteredTableRows: const [],
          selectedTestAnnotation: null,
          uploadedTestReports: const [],
          doctorNames: const [],
        );

  TestAnalysisDataEntryState copyWith({
    String? selectedDate,
    RequestStatus? testAnalysisDataEntryStatus,
    bool? isFormValidated,
    bool? isTestPictureSelected,
    String? isTestNameSelected,
    String? isTestGroupNameSelected,
    String? isTestCodeSelected,
    List<String>? countriesNames,
    String? message,
    String? selectedCountryName,
    UploadImageRequestStatus? testImageRequestStatus,
    UploadReportRequestStatus? testReportRequestStatus,
    List<String>? testCodes,
    List<String>? testGroupNames,
    List<String>? testNames,
    String? selectedTestAnnotation,
    List<TableRowReponseModel>? testTableRowsData,
    List<TableRowReponseModel>? enteredTableRows,
    String? selectedHospitalName,
    String? selectedDoctorName,
    String? selectedSymptomsForProcedure,
    String? selectedNoOftimesTestPerformed,
    bool? isEditMode,
    String? updatedTestId,
    List<String>? uploadedTestImages,
    List<String>? uploadedTestReports,
    List<String>? doctorNames,
  }) {
    return TestAnalysisDataEntryState(
        selectedDate: selectedDate ?? this.selectedDate,
        testAnalysisDataEntryStatus:
            testAnalysisDataEntryStatus ?? this.testAnalysisDataEntryStatus,
        isFormValidated: isFormValidated ?? this.isFormValidated,
        isTestPictureSelected:
            isTestPictureSelected ?? this.isTestPictureSelected,
        isTestNameSelected: isTestNameSelected ?? this.isTestNameSelected,
        isTestCodeSelected: isTestCodeSelected ?? this.isTestCodeSelected,
        countriesNames: countriesNames ?? this.countriesNames,
        message: message ?? this.message,
        selectedCountryName: selectedCountryName ?? this.selectedCountryName,
        testImageRequestStatus:
            testImageRequestStatus ?? this.testImageRequestStatus,
        testReportRequestStatus:
            testReportRequestStatus ?? this.testReportRequestStatus,
        testCodes: testCodes ?? this.testCodes,
        selectedTestAnnotation:
            selectedTestAnnotation ?? this.selectedTestAnnotation,
        isTestGroupNameSelected:
            isTestGroupNameSelected ?? this.isTestGroupNameSelected,
        testGroupNames: testGroupNames ?? this.testGroupNames,
        testNames: testNames ?? this.testNames,
        testTableRowsData: testTableRowsData ?? this.testTableRowsData,
        enteredTableRows: enteredTableRows ?? this.enteredTableRows,
        selectedHospitalName: selectedHospitalName ?? this.selectedHospitalName,
        selectedDoctorName: selectedDoctorName ?? this.selectedDoctorName,
        selectedSymptomsForProcedure:
            selectedSymptomsForProcedure ?? this.selectedSymptomsForProcedure,
        selectedNoOftimesTestPerformed: selectedNoOftimesTestPerformed ??
            this.selectedNoOftimesTestPerformed,
        isEditMode: isEditMode ?? this.isEditMode,
        updatedTestId: updatedTestId ?? this.updatedTestId,
        uploadedTestImages: uploadedTestImages ?? this.uploadedTestImages,
        uploadedTestReports: uploadedTestReports ?? this.uploadedTestReports,
        doctorNames: doctorNames ?? this.doctorNames);
  }

  @override
  List<Object?> get props => [
        selectedDate,
        testAnalysisDataEntryStatus,
        isFormValidated,
        isTestPictureSelected,
        isTestNameSelected,
        isTestCodeSelected,
        isTestGroupNameSelected,
        countriesNames,
        message,
        selectedCountryName,
        testImageRequestStatus,
        testReportRequestStatus,
        testCodes,
        selectedTestAnnotation,
        testGroupNames,
        testNames,
        testTableRowsData,
        enteredTableRows,
        selectedHospitalName,
        selectedDoctorName,
        selectedSymptomsForProcedure,
        selectedNoOftimesTestPerformed,
        isEditMode,
        updatedTestId,
        uploadedTestImages,
        uploadedTestReports,
        doctorNames,
      ];
}
