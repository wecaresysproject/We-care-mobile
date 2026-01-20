part of 'physical_activaty_view_cubit.dart';

class PhysicalActivatyViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final PhysicalActivityMetricsResponse? physicalActivitySLides;
  final int followUpNutrationViewCurrentTabIndex;
  final List<int> availableYears;
  final List<String> availableDates;
  final List<PhysicalActivityDayModel> followUpReportsRows;

  const PhysicalActivatyViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.availableYears = const [],
    this.physicalActivitySLides,
    this.availableDates = const [],
    this.followUpNutrationViewCurrentTabIndex = 0,
    this.followUpReportsRows = const [],
  });

  factory PhysicalActivatyViewState.initial() {
    return PhysicalActivatyViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      availableYears: const [],
      physicalActivitySLides: null,
      availableDates: const [],
      followUpNutrationViewCurrentTabIndex: 0,
      followUpReportsRows: const [],
    );
  }

  PhysicalActivatyViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? availableYears,
    List<String>? availableDates,
    PhysicalActivityMetricsResponse? physicalActivitySLides,
    int? followUpNutrationViewCurrentTabIndex,
    List<PhysicalActivityDayModel>? followUpReportsRows,
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
      followUpReportsRows: followUpReportsRows ?? this.followUpReportsRows,
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
        followUpReportsRows,
      ];
}
