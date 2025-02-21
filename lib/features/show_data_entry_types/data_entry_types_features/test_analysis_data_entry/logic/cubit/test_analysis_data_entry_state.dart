part of 'test_analysis_data_entry_cubit.dart';

@immutable
class TestAnalysisDataEntryState extends Equatable {
  final RequestStatus testAnalysisDataEntryStatus;

  final String? isDateSelected;
  final bool? isTestPictureSelected;
  final String? isTypeOfTestSelected;
  final String? isTypeOfTestWithAnnotationSelected;
  final bool isFormValidated;

  const TestAnalysisDataEntryState({
    this.testAnalysisDataEntryStatus = RequestStatus.initial,
    this.isDateSelected,
    this.isFormValidated = false,
    this.isTestPictureSelected,
    this.isTypeOfTestSelected,
    this.isTypeOfTestWithAnnotationSelected,
  });
  const TestAnalysisDataEntryState.initial()
      : this(
          isDateSelected: null,
          testAnalysisDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          isTestPictureSelected: null,
          isTypeOfTestSelected: null,
          isTypeOfTestWithAnnotationSelected: null,
        );

  TestAnalysisDataEntryState copyWith({
    String? isDateSelected,
    RequestStatus? testAnalysisDataEntryStatus,
    bool? isFormValidated,
    bool? isTestPictureSelected,
    String? isTypeOfTestSelected,
    String? isTypeOfTestWithAnnotationSelected,
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
      ];
}
