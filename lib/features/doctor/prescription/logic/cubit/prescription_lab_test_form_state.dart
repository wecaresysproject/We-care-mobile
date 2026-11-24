part of 'prescription_lab_test_form_cubit.dart';

@immutable
class PrescriptionLabTestFormState extends Equatable {
  const PrescriptionLabTestFormState({
    this.isEditMode = false,
    this.groupNames = const [],
    this.groupsLoadingState = OptionsLoadingState.loading,
    this.selectedGroupName,
    this.groupTests = const [],
    this.groupTestsLoadingState = OptionsLoadingState.loaded,
    this.selectedGroupTests = const [],
    this.testsGroupName,
    this.testNamesEn = const [],
    this.testNamesEnLoadingState = OptionsLoadingState.loading,
    this.selectedTestNameEn,
  });

  final bool isEditMode;

  /// المجموعة
  final List<String> groupNames;
  final OptionsLoadingState groupsLoadingState;
  final String? selectedGroupName;

  /// The tests listed for the picked group or English name, and the ones
  /// the doctor picked among them.
  final List<String> groupTests;
  final OptionsLoadingState groupTestsLoadingState;
  final List<String> selectedGroupTests;

  /// The group the listed tests belong to — the English name's group.
  final String? testsGroupName;

  /// الاسم (En)
  final List<String> testNamesEn;
  final OptionsLoadingState testNamesEnLoadingState;
  final String? selectedTestNameEn;

  bool get hasGroup => _isFilled(selectedGroupName);

  bool get hasTestNameEn => _isFilled(selectedTestNameEn);

  bool get areAllGroupTestsSelected =>
      groupTests.isNotEmpty && groupTests.every(selectedGroupTests.contains);

  /// A group or an English name, with at least one listed test picked —
  /// when nothing is listed (e.g. a typed name), the pick alone is enough.
  bool get isFormValid {
    if (!hasGroup && !hasTestNameEn) return false;
    if (groupTestsLoadingState != OptionsLoadingState.loaded) return false;
    return groupTests.isEmpty || selectedGroupTests.isNotEmpty;
  }

  static bool _isFilled(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// Selections take a function, so `null` (cleared) can be told apart from
  /// "not passed".
  PrescriptionLabTestFormState copyWith({
    bool? isEditMode,
    List<String>? groupNames,
    OptionsLoadingState? groupsLoadingState,
    String? Function()? selectedGroupName,
    List<String>? groupTests,
    OptionsLoadingState? groupTestsLoadingState,
    List<String>? selectedGroupTests,
    String? Function()? testsGroupName,
    List<String>? testNamesEn,
    OptionsLoadingState? testNamesEnLoadingState,
    String? Function()? selectedTestNameEn,
  }) {
    return PrescriptionLabTestFormState(
      isEditMode: isEditMode ?? this.isEditMode,
      groupNames: groupNames ?? this.groupNames,
      groupsLoadingState: groupsLoadingState ?? this.groupsLoadingState,
      selectedGroupName: selectedGroupName != null
          ? selectedGroupName()
          : this.selectedGroupName,
      groupTests: groupTests ?? this.groupTests,
      groupTestsLoadingState:
          groupTestsLoadingState ?? this.groupTestsLoadingState,
      selectedGroupTests: selectedGroupTests ?? this.selectedGroupTests,
      testsGroupName:
          testsGroupName != null ? testsGroupName() : this.testsGroupName,
      testNamesEn: testNamesEn ?? this.testNamesEn,
      testNamesEnLoadingState:
          testNamesEnLoadingState ?? this.testNamesEnLoadingState,
      selectedTestNameEn: selectedTestNameEn != null
          ? selectedTestNameEn()
          : this.selectedTestNameEn,
    );
  }

  @override
  List<Object?> get props => [
        isEditMode,
        groupNames,
        groupsLoadingState,
        selectedGroupName,
        groupTests,
        groupTestsLoadingState,
        selectedGroupTests,
        testsGroupName,
        testNamesEn,
        testNamesEnLoadingState,
        selectedTestNameEn,
      ];
}
