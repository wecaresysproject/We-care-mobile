import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';

class TestAnalysisViewState extends Equatable {
  final RequestStatus requestStatus;
  final List<int> yearsFilter;
  final List<AnalysisSummarizedData> analysisSummarizedDataList;
  final AnalysisDetailedData? selectedAnalysisDetails;
  final String? message;
  final bool isDeleteRequest;

  const TestAnalysisViewState({
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.analysisSummarizedDataList = const [],
    this.selectedAnalysisDetails,
    this.message,
    this.isDeleteRequest = false,
  });

  factory TestAnalysisViewState.initial() {
    return TestAnalysisViewState(
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      analysisSummarizedDataList: const [],
      selectedAnalysisDetails: null,
      message: null,
      isDeleteRequest: false,
    );
  }

  TestAnalysisViewState copyWith({
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<AnalysisSummarizedData>? analysisSummarizedDataList,
    AnalysisDetailedData? selectedAnalysisDetails,
    String? message,
    bool? isDeleteRequest,
  }) {
    return TestAnalysisViewState(
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      analysisSummarizedDataList:
          analysisSummarizedDataList ?? this.analysisSummarizedDataList,
      selectedAnalysisDetails:
          selectedAnalysisDetails ?? this.selectedAnalysisDetails,
      message: message ?? this.message,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        yearsFilter,
        analysisSummarizedDataList,
        selectedAnalysisDetails,
        message,
        isDeleteRequest,
      ];
}
