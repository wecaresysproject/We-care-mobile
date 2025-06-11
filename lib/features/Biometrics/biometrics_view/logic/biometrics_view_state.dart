import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';

class BiometricsViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableBiometricNames;
  final List<int> yearsFilter;
  final List<int> daysFilter;
  final List<int> monthFilter;
  final List<BiometricsDatasetModel> biometricsData;

  const BiometricsViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.availableBiometricNames = const [],
    this.daysFilter = const [],
    this.monthFilter = const [],
    this.biometricsData = const [],
  });

  factory BiometricsViewState.initial() {
    return BiometricsViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [
      ],
      availableBiometricNames: const [
  ],
      daysFilter: const [
      ],
      monthFilter: const [
      ],
      biometricsData: const [],
    );
  }

  BiometricsViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? availableBiometricNames,
    List<int>? daysFilter,
    List<int>? monthFilter,
    List<BiometricsDatasetModel>? biometricsData,
  }) {
    return BiometricsViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      availableBiometricNames: availableBiometricNames ?? this.availableBiometricNames,
      daysFilter: daysFilter ?? this.daysFilter,
      monthFilter: monthFilter ?? this.monthFilter,
      biometricsData: biometricsData ?? this.biometricsData,
    );
  }


  @override
  List<Object?> get props => [
    requestStatus,
    responseMessage,
    availableBiometricNames,
    yearsFilter,
    daysFilter,
    monthFilter,  
    biometricsData,
      ];
}
