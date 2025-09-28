part of 'nutration_view_cubit.dart';

class NutrationViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableBiometricNames;
  final List<int> weaklyPlanYearsFilter;
  final List<int> monthlyPlanYearsFilter;
  final List<int> monthFilter;
  final List<BiometricsDatasetModel> biometricsData;
  final CurrentBioMetricsData? currentBiometricsData;

  const NutrationViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.weaklyPlanYearsFilter = const [],
    this.availableBiometricNames = const [],
    this.monthlyPlanYearsFilter = const [],
    this.monthFilter = const [],
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
      monthFilter: const [],
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
    List<int>? monthFilter,
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
      monthFilter: monthFilter ?? this.monthFilter,
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
        monthFilter,
        biometricsData,
        currentBiometricsData,
      ];
}
