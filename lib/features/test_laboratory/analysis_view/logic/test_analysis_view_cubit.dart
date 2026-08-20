import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/debouncer.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';
import 'package:we_care/features/test_laboratory/data/models/get_similar_tests_response_model.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_view_repo.dart';

class TestAnalysisViewCubit extends Cubit<TestAnalysisViewState> {
  TestAnalysisViewCubit(this.testAnalysisViewRepo, this.appSharedRepo)
      : super(TestAnalysisViewState.initial());
  final TestAnalysisViewRepo testAnalysisViewRepo;
  final AppSharedRepo appSharedRepo;
  final resultEditingController = TextEditingController();
  final searchController = TextEditingController();

  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> init() async {
    await emitTests();
    await emitYearsFilter();
    await emitGroupNamesFilter();
    await emitEnglishTestNamesFilter();
    await emitModuleGuidanceData();
  }

  Future<void> emitModuleGuidanceData() async {
    final response = await appSharedRepo.getModuleGuidance(
      WeCareMedicalModules.labTestsView.name,
    );
    response.when(success: (response) async {
      emit(state.copyWith(
        moduleGuidanceData: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        moduleGuidanceData: null,
      ));
    });
  }

  Future<void> emitTests({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await testAnalysisViewRepo.getTests(
        page: page ?? currentPage, pageSize: pageSize ?? this.pageSize);

    result.when(success: (response) {
      final newTestAnalysisTests = response.data;

      // Update hasMore based on whether we got a full page of results
      hasMore = newTestAnalysisTests.length >= (pageSize ?? this.pageSize);

      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        analysisSummarizedDataList: page == 1 || page == null
            ? newTestAnalysisTests
            : [...state.analysisSummarizedDataList, ...newTestAnalysisTests],
        originalList: newTestAnalysisTests,
        message: response.message,
        isLoadingMore: false,
      ));

      if (page == null || page == 1) {
        currentPage = 1;
      } else {
        currentPage = page;
      }
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        message: error.errors.first,
        isLoadingMore: false,
      ));
    });
  }

  void onSearchChanged({required String query}) {
    Debouncer(
      milliseconds: 300,
    ).call(
      () {
        search(query);
      },
    );
  }

  void search(String query) {
    final q = query.toLowerCase();

    final filtered = state.originalList.where((item) {
      return item.testName.toLowerCase().contains(q) ||
          item.testNameEnglish.toLowerCase().contains(q);
    }).toList();

    emit(
      state.copyWith(
        analysisSummarizedDataList: filtered,
      ),
    );
  }

  Future<void> loadMoreMedicines() async {
    if (!hasMore || isLoadingMore) return;

    await emitTests(page: currentPage + 1);
  }

  Future<void> emitYearsFilter() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getYearsFilter();
    response.when(success: (response) async {
      response.add(0);
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitGroupNamesFilter() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getGroupNamesFilter();
    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        groupNamesFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitEnglishTestNamesFilter() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getEnglishTestNamesFilter();
    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        englishTestNamesFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitFilteredData(
      int? year, String? group, String? englishTestName) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getFilteredTests(year,
        groupName: group, englishTestName: englishTestName);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        analysisSummarizedDataList: response.data,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitTestbyId(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getTestbyId(id);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedAnalysisDetails: response.data,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitDeleteTest(String id, String testName) async {
    emit(state.copyWith(
        requestStatus: RequestStatus.loading, isDeleteRequest: true));

    final response = await testAnalysisViewRepo.deleteAnalysisById(
        id, AppStrings.arabicLang, AppStrings.arabicLang, testName);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        message: response.message,
        isDeleteRequest: false,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        message: error.errors.first,
      ));
    });
  }

  Future<void> emitGetSimilarTests({required String testName}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response =
        await testAnalysisViewRepo.getSimilarTests(query: testName);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        getSimilarTestsResponseModel: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        message: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  /// A test whose `writtenPercent` came back as a real number is edited with
  /// the number pad. One that came back null has no percentage to type, so the
  /// user picks a descriptive result from the catalogue instead.
  Future<void> startEditingResult(SimilarTests test) async {
    final isNumeric = test.writtenPercent != null;

    emit(state.copyWith(
      isEditing: true,
      editingId: () => test.id,
      currentResult: () =>
          test.writtenPercent?.toString() ?? test.resultAsText,
      editMode: () =>
          isNumeric ? ResultEditMode.numeric : ResultEditMode.descriptive,
      // Start from whatever is already recorded so reopening the editor shows
      // the current choice rather than an empty field.
      selectedChoiceForEdit: () => isNumeric ? null : test.resultAsText,
      editingTestChoices: const [],
    ));

    resultEditingController.text =
        isNumeric ? test.writtenPercent!.toString() : '';

    if (!isNumeric) {
      await emitTestChoices(testName: test.testName);
    }
  }

  void cancelEditingResult() {
    resultEditingController.clear();
    emit(state.copyWith(
      isEditing: false,
      editingId: () => null,
      currentResult: () => null,
      editMode: () => null,
      selectedChoiceForEdit: () => null,
      editingTestChoices: const [],
      isLoadingEditChoices: false,
    ));
  }

  Future<void> emitTestChoices({required String testName}) async {
    emit(state.copyWith(isLoadingEditChoices: true));

    final response =
        await testAnalysisViewRepo.getTestChoices(testName: testName);

    response.when(
      success: (choices) {
        emit(state.copyWith(
          editingTestChoices: choices,
          isLoadingEditChoices: false,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          editingTestChoices: const [],
          isLoadingEditChoices: false,
          message: error.errors.first,
        ));
      },
    );
  }

  void selectDescriptiveResult(String choice) {
    emit(state.copyWith(selectedChoiceForEdit: () => choice));
  }

  Future<void> updateTestResult({required String testName}) async {
    final id = state.editingId;
    if (id == null) return;

    final isNumeric = state.editMode == ResultEditMode.numeric;
    final typedPercent =
        isNumeric ? double.tryParse(resultEditingController.text.trim()) : null;

    // Guard both editors: the numeric one used to `double.parse` straight from
    // the controller and threw on empty or malformed input.
    if (isNumeric && typedPercent == null) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        message: "من فضلك أدخل نتيجة رقمية صحيحة",
      ));
      return;
    }
    if (!isNumeric && state.selectedChoiceForEdit == null) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        message: "من فضلك اختر نتيجة وصفية",
      ));
      return;
    }

    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.editTestResultByIdAndName(
      id: id,
      testName: testName,
      writtenPercent: typedPercent,
      selectedChoice: isNumeric ? null : state.selectedChoiceForEdit,
      testChoices: isNumeric ? const [] : state.editingTestChoices,
    );

    await response.when(
      success: (message) async {
        // Close the editor *before* refetching: the list only rebuilds while
        // `isEditing` is false, so refreshing first left the card showing the
        // old value until the screen was reopened.
        cancelEditingResult();
        await emitGetSimilarTests(testName: testName);
        emit(state.copyWith(message: message));
      },
      failure: (error) async {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          message: error.errors.first,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    resultEditingController.dispose();
    searchController.dispose();
    return super.close();
  }
}
