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

  final List<AlternativeFoodCategoryModel> foodAlternatives;

  const NutrationViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.weaklyPlanYearsFilter = const [],
    this.weeklyNutrationDocuments = const [],
    this.monthlyNutrationDocuments = const [],
    this.monthlyPlanYearsFilter = const [],
    this.monthlyPlanDateRangesFilter = const [],
    this.weeklyPlanDateRangesFilter = const [],
    this.foodAlternatives = const [],
    this.followUpNutrationViewCurrentTabIndex = 0,
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
      foodAlternatives: const [],
      followUpNutrationViewCurrentTabIndex: 0,
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
    List<AlternativeFoodCategoryModel>? foodAlternatives,
    int? followUpNutrationViewCurrentTabIndex,
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
      foodAlternatives: foodAlternatives ?? this.foodAlternatives,
      followUpNutrationViewCurrentTabIndex:
          followUpNutrationViewCurrentTabIndex ??
              this.followUpNutrationViewCurrentTabIndex,
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
        foodAlternatives,
      ];
}
