import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_similar_tests_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';

class TestAnalysisViewState extends Equatable {
  final RequestStatus requestStatus;
  final List<int> yearsFilter;
  final List<AnalysisSummarizedData> analysisSummarizedDataList;
  final List<AnalysisSummarizedData> originalList;
  final AnalysisDetailedData? selectedAnalysisDetails;
  final String? message;
  final bool isDeleteRequest;
  final GetSimilarTestsResponseModel? getSimilarTestsResponseModel;
  final bool isEditing;
  final String? editingId;
  final String? currentResult;
  final bool isLoadingMore;
  final List<String>? groupNamesFilter;
  final List<String>? codesFilter;

  const TestAnalysisViewState({
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.analysisSummarizedDataList = const [],
    this.originalList = const [],
    this.selectedAnalysisDetails,
    this.message,
    this.isDeleteRequest = false,
    this.getSimilarTestsResponseModel,
    this.isEditing = false,
    this.editingId,
    this.currentResult,
    this.isLoadingMore = false,
    this.groupNamesFilter,
    this.codesFilter,
  });

  factory TestAnalysisViewState.initial() {
    return TestAnalysisViewState(
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      analysisSummarizedDataList: const [],
      originalList: const [],
      selectedAnalysisDetails: null,
      message: null,
      isDeleteRequest: false,
      getSimilarTestsResponseModel: null,
      isEditing: false,
      editingId: null,
      currentResult: null,
      isLoadingMore: false,
      groupNamesFilter: null,
      codesFilter: null,
    );
  }

  TestAnalysisViewState copyWith(
      {RequestStatus? requestStatus,
      List<int>? yearsFilter,
      List<AnalysisSummarizedData>? analysisSummarizedDataList,
      List<AnalysisSummarizedData>? originalList,
      AnalysisDetailedData? selectedAnalysisDetails,
      String? message,
      bool? isDeleteRequest,
      GetSimilarTestsResponseModel? getSimilarTestsResponseModel,
      bool? isEditing,
      String? editingId,
      bool? isLoadingMore,
      String? currentResult, List<String>? groupNamesFilter, List<String>? codesFilter}) {
    return TestAnalysisViewState(
        requestStatus: requestStatus ?? this.requestStatus,
        yearsFilter: yearsFilter ?? this.yearsFilter,
        analysisSummarizedDataList:
            analysisSummarizedDataList ?? this.analysisSummarizedDataList,
        originalList: originalList ?? this.originalList,
        selectedAnalysisDetails:
            selectedAnalysisDetails ?? this.selectedAnalysisDetails,
        message: message ?? this.message,
        isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
        getSimilarTestsResponseModel:
            getSimilarTestsResponseModel ?? this.getSimilarTestsResponseModel,
        isEditing: isEditing ?? this.isEditing,
        editingId: editingId ?? this.editingId,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        groupNamesFilter: groupNamesFilter ?? this.groupNamesFilter,
        codesFilter: codesFilter ?? this.codesFilter,
        currentResult: currentResult ?? this.currentResult);
  }

  @override
  List<Object?> get props => [
        requestStatus,
        yearsFilter,
        analysisSummarizedDataList,
        originalList,
        selectedAnalysisDetails,
        message,
        isDeleteRequest,
        getSimilarTestsResponseModel,
        isEditing,
        groupNamesFilter,
        codesFilter,
        editingId,
        currentResult,
        isLoadingMore,
      ];
}
