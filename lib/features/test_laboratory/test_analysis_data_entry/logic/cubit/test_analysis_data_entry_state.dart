part of 'test_analysis_data_entry_cubit.dart';

@immutable
class TestAnalysisDataEntryState extends Equatable {
  final RequestStatus testAnalysisDataEntryStatus;

  final String? isDateSelected;
  final bool? isTestPictureSelected;
  final String? isTestNameSelected;
  final String? isTestGroupNameSelected;
  final String? isTestCodeSelected;
  final bool isFormValidated;
  final List<String> countriesNames;
  final String? selectedCountryName;
  final UploadImageRequestStatus testImageRequestStatus;
  final UploadReportRequestStatus testReportRequestStatus;
  final String testPictureUploadedUrl;
  final String testReportUploadedUrl;
  final String message; // error or success message
  final String? selectedTestAnnotation;

  final List<String> testCodes;
  final List<String> testGroupNames;
  final List<String> testNames;

  const TestAnalysisDataEntryState({
    this.testAnalysisDataEntryStatus = RequestStatus.initial,
    this.countriesNames = const [],
    this.isDateSelected,
    this.isFormValidated = false,
    this.isTestPictureSelected,
    this.isTestNameSelected,
    this.isTestGroupNameSelected,
    this.selectedCountryName,
    this.isTestCodeSelected,
    this.message = '',
    this.testImageRequestStatus = UploadImageRequestStatus.initial,
    this.testReportRequestStatus = UploadReportRequestStatus.initial,
    this.testPictureUploadedUrl = '',
    this.testReportUploadedUrl = '',
    this.testCodes = const [],
    this.testGroupNames = const [],
    this.testNames = const [],
    this.selectedTestAnnotation,
  });
  const TestAnalysisDataEntryState.initial()
      : this(
          isDateSelected: null,
          testAnalysisDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          isTestPictureSelected: null,
          isTestNameSelected: null,
          isTestGroupNameSelected: null,
          isTestCodeSelected: null,
          selectedCountryName: null,
          message: '',
          testImageRequestStatus: UploadImageRequestStatus.initial,
          testReportRequestStatus: UploadReportRequestStatus.initial,
          testPictureUploadedUrl: '',
        );

  TestAnalysisDataEntryState copyWith({
    String? isDateSelected,
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
    String? testPictureUploadedUrl,
    String? testReportUploadedUrl,
    List<String>? testCodes,
    List<String>? testGroupNames,
    List<String>? testNames,
    String? selectedTestAnnotation,
  }) {
    return TestAnalysisDataEntryState(
      isDateSelected: isDateSelected ?? this.isDateSelected,
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
      testPictureUploadedUrl:
          testPictureUploadedUrl ?? this.testPictureUploadedUrl,
      testReportUploadedUrl:
          testReportUploadedUrl ?? this.testReportUploadedUrl,
      testCodes: testCodes ?? this.testCodes,
      selectedTestAnnotation:
          selectedTestAnnotation ?? this.selectedTestAnnotation,
      isTestGroupNameSelected:
          isTestGroupNameSelected ?? this.isTestGroupNameSelected,
      testGroupNames: testGroupNames ?? this.testGroupNames,
      testNames: testNames ?? this.testNames,
    );
  }

  @override
  List<Object?> get props => [
        isDateSelected,
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
        testPictureUploadedUrl,
        testReportUploadedUrl,
        testCodes,
        selectedTestAnnotation,
        testGroupNames,
        testNames,
      ];
}
