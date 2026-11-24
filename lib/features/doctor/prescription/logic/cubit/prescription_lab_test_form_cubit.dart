import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_lab_test_model.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_data_entry_repo.dart';

part 'prescription_lab_test_form_state.dart';

/// The add / edit lab test sheet of the doctor's prescription. Reuses the
/// lab tests module's lookups. The doctor picks either a group or an
/// English test name (not both), then some of the tests listed for it.
class PrescriptionLabTestFormCubit extends Cubit<PrescriptionLabTestFormState>
    with SafeEmitMixin {
  PrescriptionLabTestFormCubit(this._labTestsRepo)
      : super(const PrescriptionLabTestFormState());

  final TestAnalysisDataEntryRepo _labTestsRepo;

  /// [initialLabTest] fills the form when editing an existing row.
  Future<void> init(PrescriptionLabTestModel? initialLabTest) async {
    if (initialLabTest != null) {
      safeEmit(
        state.copyWith(
          isEditMode: true,
          selectedGroupName: () => initialLabTest.groupName,
          selectedGroupTests: initialLabTest.tests,
          testsGroupName: () => initialLabTest.groupName,
          selectedTestNameEn: () => initialLabTest.testNameEn,
        ),
      );
    }
    await Future.wait([
      loadGroupNames(),
      loadTestNamesEn(),
      if (initialLabTest != null) loadTests(),
    ]);
  }

  Future<void> loadGroupNames() async {
    safeEmit(state.copyWith(groupsLoadingState: OptionsLoadingState.loading));
    final response = await _labTestsRepo.getListOfTestGroupNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (groupNames) => safeEmit(
        state.copyWith(
          groupNames: groupNames,
          groupsLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(groupsLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  Future<void> loadTestNamesEn() async {
    safeEmit(
      state.copyWith(testNamesEnLoadingState: OptionsLoadingState.loading),
    );
    final response = await _labTestsRepo.getTestEnglishNames(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (testNamesEn) => safeEmit(
        state.copyWith(
          testNamesEn: testNamesEn,
          testNamesEnLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(testNamesEnLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  /// What the tests are loaded for: the group, or the English test name.
  String? get _testsQuery =>
      state.hasGroup ? state.selectedGroupName : state.selectedTestNameEn;

  /// The tests of the picked group — or of the picked English test's group
  /// — the same table the lab tests module shows after either pick.
  Future<void> loadTests() async {
    final query = _testsQuery;
    if (query == null) return;
    final isByGroup = state.hasGroup;
    safeEmit(
      state.copyWith(groupTestsLoadingState: OptionsLoadingState.loading),
    );
    final response = await _labTestsRepo.getTableDetails(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      groupNameQuery: isByGroup ? query : null,
      englishTestNameQuery: isByGroup ? null : query,
    );
    // The doctor may have picked something else while this was loading.
    if (_testsQuery != query) return;
    response.when(
      success: (rows) {
        final testNames = <String>{
          for (final row in rows)
            if (row.testName.trim().isNotEmpty) row.testName.trim(),
        }.toList();
        final groupNames = rows
            .map((row) => row.groupName.trim())
            .where((name) => name.isNotEmpty);
        // Picking an English name pre-selects that test when it's listed.
        final preselected = !isByGroup && state.selectedGroupTests.isEmpty
            ? testNames
                .where((t) => t.toLowerCase() == query.trim().toLowerCase())
                .toList()
            : state.selectedGroupTests;
        safeEmit(
          state.copyWith(
            groupTests: testNames,
            testsGroupName: () => groupNames.isEmpty ? null : groupNames.first,
            selectedGroupTests: preselected,
            groupTestsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (_) => safeEmit(
        state.copyWith(groupTestsLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  /// Empties the loaded tests and the picks among them.
  PrescriptionLabTestFormState _withoutTests(PrescriptionLabTestFormState s) =>
      s.copyWith(
        groupTests: const [],
        testsGroupName: () => null,
        groupTestsLoadingState: OptionsLoadingState.loaded,
        selectedGroupTests: const [],
      );

  Future<void> updateGroupName(String groupName) async {
    if (groupName == state.selectedGroupName) return;
    safeEmit(_withoutTests(state.copyWith(selectedGroupName: () => groupName)));
    await loadTests();
  }

  void clearGroupName() =>
      safeEmit(_withoutTests(state.copyWith(selectedGroupName: () => null)));

  Future<void> updateTestNameEn(String testNameEn) async {
    if (testNameEn == state.selectedTestNameEn) return;
    safeEmit(
      _withoutTests(state.copyWith(selectedTestNameEn: () => testNameEn)),
    );
    await loadTests();
  }

  void clearTestNameEn() =>
      safeEmit(_withoutTests(state.copyWith(selectedTestNameEn: () => null)));

  void toggleGroupTest(String testName) {
    final selected = [...state.selectedGroupTests];
    selected.contains(testName)
        ? selected.remove(testName)
        : selected.add(testName);
    safeEmit(state.copyWith(selectedGroupTests: selected));
  }

  /// Selects every listed test, or none when all are selected.
  void toggleAllGroupTests() => safeEmit(
        state.copyWith(
          selectedGroupTests:
              state.areAllGroupTestsSelected ? const [] : state.groupTests,
        ),
      );

  /// The filled row, or null while the form is incomplete.
  PrescriptionLabTestModel? buildLabTest() {
    if (!state.isFormValid) return null;
    // Keeps the listed order, not the tap order; edited rows may hold tests
    // the list no longer has, so those stay at the end.
    final tests = [
      ...state.groupTests.where(state.selectedGroupTests.contains),
      ...state.selectedGroupTests.where((t) => !state.groupTests.contains(t)),
    ];
    if (state.hasGroup) {
      return PrescriptionLabTestModel(
        groupName: state.selectedGroupName!.trim(),
        tests: tests,
      );
    }
    return PrescriptionLabTestModel(
      groupName: state.testsGroupName,
      testNameEn: state.selectedTestNameEn!.trim(),
      tests: tests,
    );
  }
}
