part of 'test_analysis_data_entry_cubit.dart';

@immutable
class TestAnalysisDataEntryState extends Equatable {
  final RequestStatus testAnalysisDataEntryStatus;

  final String? selectedDate;
  final String? isTestNameSelected;
  final String? isTestGroupNameSelected;
  final String? isTestCodeSelected;
  final bool isFormValidated;
  final List<String> countriesNames;
  final List<String> doctorNames;
  final List<String> labCenters;
  final List<String> hospitalNames;
  final String? selectedCountryName;
  final String? selectedHospitalName;
  final String? selectedDoctorName;
  final String? selectedNoOftimesTestPerformed;
  final String? selectedLabCenter;
  final List<String> symptomsRequiringIntervention; // الاعراض المستدعية للاعراض

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
    this.isTestNameSelected,
    this.isTestGroupNameSelected,
    this.selectedCountryName,
    this.selectedHospitalName,
    this.selectedDoctorName,
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
    this.labCenters = const [],
    this.hospitalNames = const [],
    this.selectedLabCenter,
    this.symptomsRequiringIntervention = const [],
  });
  const TestAnalysisDataEntryState.initial()
      : this(
          selectedDate: null,
          testAnalysisDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          isTestNameSelected: null,
          isTestGroupNameSelected: null,
          isTestCodeSelected: null,
          selectedCountryName: null,
          selectedHospitalName: null,
          selectedDoctorName: null,
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
          labCenters: const [],
          hospitalNames: const [],
          selectedLabCenter: null,
          symptomsRequiringIntervention: const [],
        );

  TestAnalysisDataEntryState copyWith({
    String? selectedDate,
    RequestStatus? testAnalysisDataEntryStatus,
    bool? isFormValidated,
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
    String? selectedNoOftimesTestPerformed,
    bool? isEditMode,
    String? updatedTestId,
    List<String>? uploadedTestImages,
    List<String>? uploadedTestReports,
    List<String>? doctorNames,
    List<String>? labCenters,
    List<String>? hospitalNames,
    String? selectedLabCenter,
    List<String>? symptomsRequiringIntervention,
  }) {
    return TestAnalysisDataEntryState(
      selectedDate: selectedDate ?? this.selectedDate,
      testAnalysisDataEntryStatus:
          testAnalysisDataEntryStatus ?? this.testAnalysisDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
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
      selectedNoOftimesTestPerformed:
          selectedNoOftimesTestPerformed ?? this.selectedNoOftimesTestPerformed,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedTestId: updatedTestId ?? this.updatedTestId,
      uploadedTestImages: uploadedTestImages ?? this.uploadedTestImages,
      uploadedTestReports: uploadedTestReports ?? this.uploadedTestReports,
      doctorNames: doctorNames ?? this.doctorNames,
      labCenters: labCenters ?? this.labCenters,
      hospitalNames: hospitalNames ?? this.hospitalNames,
      selectedLabCenter: selectedLabCenter ?? this.selectedLabCenter,
      symptomsRequiringIntervention:
          symptomsRequiringIntervention ?? this.symptomsRequiringIntervention,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        testAnalysisDataEntryStatus,
        isFormValidated,
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
        selectedNoOftimesTestPerformed,
        isEditMode,
        updatedTestId,
        uploadedTestImages,
        uploadedTestReports,
        doctorNames,
        labCenters,
        hospitalNames,
        selectedLabCenter,
        symptomsRequiringIntervention,
      ];
}
