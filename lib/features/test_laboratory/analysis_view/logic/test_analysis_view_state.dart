import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_similar_tests_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';

/// How "تعديل النتيجه" behaves for the row being edited. A test that reports a
/// numeric `writtenPercent` is edited with the number pad; one that reports it
/// as null has no percentage at all and is edited by picking a descriptive
/// result from the catalogue.
enum ResultEditMode { numeric, descriptive }

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

  /// Which editor the row being edited gets. Null when nothing is being edited.
  final ResultEditMode? editMode;

  /// Descriptive options fetched for the row being edited.
  final List<String> editingTestChoices;
  final bool isLoadingEditChoices;

  /// The descriptive option the user picked, before saving.
  final String? selectedChoiceForEdit;
  final bool isLoadingMore;
  final List<String>? groupNamesFilter;
  final List<String>? englishTestNamesFilter;

  final ModuleGuidanceDataModel? moduleGuidanceData;

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
    this.editMode,
    this.editingTestChoices = const [],
    this.isLoadingEditChoices = false,
    this.selectedChoiceForEdit,
    this.isLoadingMore = false,
    this.groupNamesFilter,
    this.englishTestNamesFilter,
    this.moduleGuidanceData,
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
      editMode: null,
      editingTestChoices: const [],
      isLoadingEditChoices: false,
      selectedChoiceForEdit: null,
      isLoadingMore: false,
      groupNamesFilter: null,
      englishTestNamesFilter: null,
      moduleGuidanceData: null,
    );
  }

  TestAnalysisViewState copyWith({
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<AnalysisSummarizedData>? analysisSummarizedDataList,
    List<AnalysisSummarizedData>? originalList,
    AnalysisDetailedData? selectedAnalysisDetails,
    String? message,
    bool? isDeleteRequest,
    GetSimilarTestsResponseModel? getSimilarTestsResponseModel,
    bool? isEditing,
    bool? isLoadingMore,

    /// Getters rather than bare values: these all have to be cleared when an
    /// edit session ends, and with the plain `value ?? this.value` form a null
    /// argument means "leave unchanged", so clearing silently does nothing.
    ValueGetter<String?>? editingId,
    ValueGetter<String?>? currentResult,
    ValueGetter<ResultEditMode?>? editMode,
    ValueGetter<String?>? selectedChoiceForEdit,
    List<String>? editingTestChoices,
    bool? isLoadingEditChoices,
    List<String>? groupNamesFilter,
    List<String>? englishTestNamesFilter,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
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
      editingId: editingId != null ? editingId() : this.editingId,
      editMode: editMode != null ? editMode() : this.editMode,
      editingTestChoices: editingTestChoices ?? this.editingTestChoices,
      isLoadingEditChoices: isLoadingEditChoices ?? this.isLoadingEditChoices,
      selectedChoiceForEdit: selectedChoiceForEdit != null
          ? selectedChoiceForEdit()
          : this.selectedChoiceForEdit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      groupNamesFilter: groupNamesFilter ?? this.groupNamesFilter,
      englishTestNamesFilter:
          englishTestNamesFilter ?? this.englishTestNamesFilter,
      currentResult:
          currentResult != null ? currentResult() : this.currentResult,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
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
        englishTestNamesFilter,
        editingId,
        currentResult,
        editMode,
        editingTestChoices,
        isLoadingEditChoices,
        selectedChoiceForEdit,
        isLoadingMore,
        moduleGuidanceData,
      ];
}
