import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/debouncer.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_view_repo.dart';

class TestAnalysisViewCubit extends Cubit<TestAnalysisViewState> {
  TestAnalysisViewCubit(this.testAnalysisViewRepo)
      : super(TestAnalysisViewState.initial());
  final TestAnalysisViewRepo testAnalysisViewRepo;
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
    await emitTestCodesFilter();
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
          item.code.toLowerCase().contains(q);
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
    Future<void> emitTestCodesFilter() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getTestCodesFilter();
    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        codesFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitFilteredData(int? year, String? group, String? code) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getFilteredTests(year, groupName: group, testCode: code);

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

  void toggleEditing(String id, String currentResult) {
    emit(state.copyWith(
      isEditing: !state.isEditing,
      editingId: id,
      currentResult: currentResult,
    ));
  }

  Future<void> updateTestResult(
      {required String id,
      required String testName,
      required double result}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.editTestResultByIdAndName(
        id: id, testName: testName, result: result);

    response.when(success: (response) async {
      await emitGetSimilarTests(testName: testName);
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        message: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        message: error.errors.first,
      ));
    });
    emit(
        state.copyWith(isEditing: false, editingId: null, currentResult: null));
  }

  @override
  Future<void> close() {
    resultEditingController.dispose();
    searchController.dispose();
    return super.close();
  }
}
