part of 'nutration_view_cubit.dart';

class NutrationViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableBiometricNames;
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
    this.availableBiometricNames = const [],
    this.monthlyPlanYearsFilter = const [],
    this.monthlyPlanDateRangesFilter = const [],
    this.weeklyPlanDateRangesFilter = const [],
    this.biometricsData = const [],
    this.currentBiometricsData,
  });

  factory NutrationViewState.initial() {
    return NutrationViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      weaklyPlanYearsFilter: const [],
      availableBiometricNames: const [],
      monthlyPlanYearsFilter: const [],
      monthlyPlanDateRangesFilter: const [],
      weeklyPlanDateRangesFilter: const [],
      biometricsData: const [],
      currentBiometricsData: null,
    );
  }

  NutrationViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? weaklyPlanYearsFilter,
    List<String>? availableBiometricNames,
    List<int>? monthlyPlanYearsFilter,
    List<String>? monthlyPlanDateRangesFilter,
    List<String>? weeklyPlanDateRangesFilter,
    List<BiometricsDatasetModel>? biometricsData,
    CurrentBioMetricsData? currentBiometricsData,
  }) {
    return NutrationViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      weaklyPlanYearsFilter:
          weaklyPlanYearsFilter ?? this.weaklyPlanYearsFilter,
      availableBiometricNames:
          availableBiometricNames ?? this.availableBiometricNames,
      monthlyPlanYearsFilter:
          monthlyPlanYearsFilter ?? this.monthlyPlanYearsFilter,
      monthlyPlanDateRangesFilter:
          monthlyPlanDateRangesFilter ?? this.monthlyPlanDateRangesFilter,
      weeklyPlanDateRangesFilter:
          weeklyPlanDateRangesFilter ?? this.weeklyPlanDateRangesFilter,
      biometricsData: biometricsData ?? this.biometricsData,
      currentBiometricsData:
          currentBiometricsData ?? this.currentBiometricsData,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        availableBiometricNames,
        weaklyPlanYearsFilter,
        monthlyPlanYearsFilter,
        monthlyPlanDateRangesFilter,
        weeklyPlanDateRangesFilter,
        biometricsData,
        currentBiometricsData,
      ];
}
