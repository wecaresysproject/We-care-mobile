import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

class BiometricsViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableBiometricNames;
  final List<int> yearsFilter;
  final List<int> daysFilter;
  final List<int> monthFilter;

  const BiometricsViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.availableBiometricNames = const [],
    this.daysFilter = const [],
    this.monthFilter = const [],
  });

  factory BiometricsViewState.initial() {
    return BiometricsViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [
        2023,
        2022,
        2021,
        2020,
        2019,
        2018,
        2017,
        2016,
        2015,
      ],
      availableBiometricNames: const [
    'الطول',
    'الوزن',
    'معدل ضربات القلب',
    'ضغط الدم',
    'مستوى السكر في الدم',
    'مستوى الكوليسترول',
    'مستوى الأكسجين في الدم',
  ],
      daysFilter: const [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
      ],
      monthFilter: const [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
      ],
    );
  }

  BiometricsViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? availableBiometricNames,
    List<int>? daysFilter,
    List<int>? monthFilter,
  }) {
    return BiometricsViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      availableBiometricNames: availableBiometricNames ?? this.availableBiometricNames,
      daysFilter: daysFilter ?? this.daysFilter,
      monthFilter: monthFilter ?? this.monthFilter,
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
      ];
}
