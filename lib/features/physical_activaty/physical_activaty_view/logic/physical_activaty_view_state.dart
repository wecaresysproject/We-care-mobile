part of 'physical_activaty_view_cubit.dart';

class PhysicalActivatyViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<NutrationDocument> weeklyNutrationDocuments;
  final List<NutrationDocument> monthlyNutrationDocuments;
  final int followUpNutrationViewCurrentTabIndex;
  final List<int> weaklyPlanYearsFilter;
  final List<int> monthlyPlanYearsFilter;
  final List<String> monthlyPlanDateRangesFilter;
  final List<String> weeklyPlanDateRangesFilter;
  final ElementData? elementRecommendation;
  final List<String> affectedOrgansList;
  final OrganNutritionalEffectsData? organNutritionalEffectsData;

  final List<AlternativeFoodCategoryModel> foodAlternatives;

  const PhysicalActivatyViewState(
      {this.responseMessage = '',
      this.requestStatus = RequestStatus.initial,
      this.weaklyPlanYearsFilter = const [],
      this.weeklyNutrationDocuments = const [],
      this.monthlyNutrationDocuments = const [],
      this.monthlyPlanYearsFilter = const [],
      this.monthlyPlanDateRangesFilter = const [],
      this.weeklyPlanDateRangesFilter = const [],
      this.foodAlternatives = const [],
      this.followUpNutrationViewCurrentTabIndex = 0,
      this.elementRecommendation,
      this.affectedOrgansList = const [],
      this.organNutritionalEffectsData});

  factory PhysicalActivatyViewState.initial() {
    return PhysicalActivatyViewState(
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
        elementRecommendation: null,
        affectedOrgansList: const [],
        organNutritionalEffectsData: null);
  }

  PhysicalActivatyViewState copyWith(
      {String? responseMessage,
      RequestStatus? requestStatus,
      List<int>? weaklyPlanYearsFilter,
      List<NutrationDocument>? weeklyNutrationDocuments,
      List<NutrationDocument>? monthlyNutrationDocuments,
      List<int>? monthlyPlanYearsFilter,
      List<String>? monthlyPlanDateRangesFilter,
      List<String>? weeklyPlanDateRangesFilter,
      List<AlternativeFoodCategoryModel>? foodAlternatives,
      int? followUpNutrationViewCurrentTabIndex,
      ElementData? elementRecommendation,
      List<String>? affectedOrgansList,
      OrganNutritionalEffectsData? organNutritionalEffectsData}) {
    return PhysicalActivatyViewState(
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
        elementRecommendation:
            elementRecommendation ?? this.elementRecommendation,
        affectedOrgansList: affectedOrgansList ?? this.affectedOrgansList,
        organNutritionalEffectsData:
            organNutritionalEffectsData ?? this.organNutritionalEffectsData);
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
        elementRecommendation,
        foodAlternatives,
        affectedOrgansList,
        organNutritionalEffectsData
      ];
}
