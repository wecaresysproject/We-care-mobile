part of 'physical_activaty_view_cubit.dart';

class PhysicalActivatyViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final PhysicalActivityMetricsResponse? physicalActivitySLides;
  final int followUpNutrationViewCurrentTabIndex;
  final List<int> availableYears;
  final List<String> availableDates;

  const PhysicalActivatyViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.availableYears = const [],
    this.physicalActivitySLides,
    this.availableDates = const [],
    this.followUpNutrationViewCurrentTabIndex = 0,
  });

  factory PhysicalActivatyViewState.initial() {
    return PhysicalActivatyViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      availableYears: const [],
      physicalActivitySLides: null,
      availableDates: const [],
      followUpNutrationViewCurrentTabIndex: 0,
    );
  }

  PhysicalActivatyViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? availableYears,
    List<String>? availableDates,
    PhysicalActivityMetricsResponse? physicalActivitySLides,
    int? followUpNutrationViewCurrentTabIndex,
  }) {
    return PhysicalActivatyViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      availableYears: availableYears ?? this.availableYears,
      availableDates: availableDates ?? this.availableDates,
      physicalActivitySLides:
          physicalActivitySLides ?? this.physicalActivitySLides,
      followUpNutrationViewCurrentTabIndex:
          followUpNutrationViewCurrentTabIndex ??
              this.followUpNutrationViewCurrentTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        physicalActivitySLides,
        availableYears,
        availableDates,
        followUpNutrationViewCurrentTabIndex,
      ];
}
