part of 'nutration_view_cubit.dart';

class NutrationViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<NutrationDocument> weeklyNutrationDocuments;
  final List<NutrationDocument> monthlyNutrationDocuments;
  final int followUpNutrationViewCurrentTabIndex;
  final List<int> weaklyPlanYearsFilter;
  final List<int> monthlyPlanYearsFilter;
  final List<String> monthlyPlanDateRangesFilter;
  final List<String> weeklyPlanDateRangesFilter;

  final List<BiometricsDatasetModel> biometricsData;
  final CurrentBioMetricsData? currentBiometricsData;

  const NutrationViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.weaklyPlanYearsFilter = const [],
    this.weeklyNutrationDocuments = const [],
    this.monthlyNutrationDocuments = const [],
    this.monthlyPlanYearsFilter = const [],
    this.monthlyPlanDateRangesFilter = const [],
    this.weeklyPlanDateRangesFilter = const [],
    this.biometricsData = const [],
    this.followUpNutrationViewCurrentTabIndex = 0,
    this.currentBiometricsData,
  });

  factory NutrationViewState.initial() {
    return NutrationViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      weaklyPlanYearsFilter: const [],
      weeklyNutrationDocuments: const [],
      monthlyNutrationDocuments: const [],
      monthlyPlanYearsFilter: const [],
      monthlyPlanDateRangesFilter: const [],
      weeklyPlanDateRangesFilter: const [],
      biometricsData: const [],
      followUpNutrationViewCurrentTabIndex: 0,
      currentBiometricsData: null,
    );
  }

  NutrationViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? weaklyPlanYearsFilter,
    List<NutrationDocument>? weeklyNutrationDocuments,
    List<NutrationDocument>? monthlyNutrationDocuments,
    List<int>? monthlyPlanYearsFilter,
    List<String>? monthlyPlanDateRangesFilter,
    List<String>? weeklyPlanDateRangesFilter,
    List<BiometricsDatasetModel>? biometricsData,
    int? followUpNutrationViewCurrentTabIndex,
    CurrentBioMetricsData? currentBiometricsData,
  }) {
    return NutrationViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      weaklyPlanYearsFilter:
          weaklyPlanYearsFilter ?? this.weaklyPlanYearsFilter,
      weeklyNutrationDocuments:
          weeklyNutrationDocuments ?? this.weeklyNutrationDocuments,
      monthlyNutrationDocuments:
          monthlyNutrationDocuments ?? this.monthlyNutrationDocuments,
      monthlyPlanYearsFilter:
          monthlyPlanYearsFilter ?? this.monthlyPlanYearsFilter,
      monthlyPlanDateRangesFilter:
          monthlyPlanDateRangesFilter ?? this.monthlyPlanDateRangesFilter,
      weeklyPlanDateRangesFilter:
          weeklyPlanDateRangesFilter ?? this.weeklyPlanDateRangesFilter,
      biometricsData: biometricsData ?? this.biometricsData,
      followUpNutrationViewCurrentTabIndex:
          followUpNutrationViewCurrentTabIndex ??
              this.followUpNutrationViewCurrentTabIndex,
      currentBiometricsData:
          currentBiometricsData ?? this.currentBiometricsData,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        weeklyNutrationDocuments,
        monthlyNutrationDocuments,
        weaklyPlanYearsFilter,
        monthlyPlanYearsFilter,
        monthlyPlanDateRangesFilter,
        weeklyPlanDateRangesFilter,
        followUpNutrationViewCurrentTabIndex,
        biometricsData,
        currentBiometricsData,
      ];
}
