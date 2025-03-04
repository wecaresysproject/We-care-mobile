part of 'test_analysis_data_entry_cubit.dart';

@immutable
class TestAnalysisDataEntryState extends Equatable {
  final RequestStatus testAnalysisDataEntryStatus;

  final String? isDateSelected;
  final bool? isTestPictureSelected;
  final String? isTypeOfTestSelected;
  final String? isTypeOfTestWithAnnotationSelected;
  final bool isFormValidated;
  final List<String> countriesNames;
  final String message; // error or success message

  const TestAnalysisDataEntryState({
    this.testAnalysisDataEntryStatus = RequestStatus.initial,
    this.countriesNames = const [],
    this.isDateSelected,
    this.isFormValidated = false,
    this.isTestPictureSelected,
    this.isTypeOfTestSelected,
    this.isTypeOfTestWithAnnotationSelected,
    this.message = '',
  });
  const TestAnalysisDataEntryState.initial()
      : this(
          isDateSelected: null,
          testAnalysisDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          isTestPictureSelected: null,
          isTypeOfTestSelected: null,
          isTypeOfTestWithAnnotationSelected: null,
          message: '',
        );

  TestAnalysisDataEntryState copyWith({
    String? isDateSelected,
    RequestStatus? testAnalysisDataEntryStatus,
    bool? isFormValidated,
    bool? isTestPictureSelected,
    String? isTypeOfTestSelected,
    String? isTypeOfTestWithAnnotationSelected,
    List<String>? countriesNames,
    String? message,
  }) {
    return TestAnalysisDataEntryState(
      isDateSelected: isDateSelected ?? this.isDateSelected,
      testAnalysisDataEntryStatus:
          testAnalysisDataEntryStatus ?? this.testAnalysisDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      isTestPictureSelected:
          isTestPictureSelected ?? this.isTestPictureSelected,
      isTypeOfTestSelected: isTypeOfTestSelected ?? this.isTypeOfTestSelected,
      isTypeOfTestWithAnnotationSelected: isTypeOfTestWithAnnotationSelected ??
          this.isTypeOfTestWithAnnotationSelected,
      countriesNames: countriesNames ?? this.countriesNames,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        isDateSelected,
        testAnalysisDataEntryStatus,
        isFormValidated,
        isTestPictureSelected,
        isTypeOfTestSelected,
        isTypeOfTestWithAnnotationSelected,
        countriesNames,
        message,
      ];
}
