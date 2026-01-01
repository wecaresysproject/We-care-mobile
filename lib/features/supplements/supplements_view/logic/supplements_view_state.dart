import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/supplements/data/models/effects_on_nutrients_model.dart';
import 'package:we_care/features/supplements/data/models/vitamins_and_supplements_models.dart';

class SupplementsViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<String> availableDateRanges;
  final List<EffectsOnNutrientsModel> effectsOnNutrientsList;
  final RequestStatus effectsOnNutrientsStatus;
  final VitaminsAndSupplementsModel? vitaminsAndSupplementsData;
  final RequestStatus vitaminsAndSupplementsStatus;

  const SupplementsViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.availableDateRanges = const [],
    this.effectsOnNutrientsList = const [],
    this.effectsOnNutrientsStatus = RequestStatus.initial,
    this.vitaminsAndSupplementsData,
    this.vitaminsAndSupplementsStatus = RequestStatus.initial,
  });

  factory SupplementsViewState.initial() {
    return SupplementsViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      availableDateRanges: const [],
      effectsOnNutrientsList: const [],
      effectsOnNutrientsStatus: RequestStatus.initial,
      vitaminsAndSupplementsData: null,
      vitaminsAndSupplementsStatus: RequestStatus.initial,
    );
  }

  SupplementsViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<String>? availableDateRanges,
    List<EffectsOnNutrientsModel>? effectsOnNutrientsList,
    RequestStatus? effectsOnNutrientsStatus,
    VitaminsAndSupplementsModel? vitaminsAndSupplementsData,
    RequestStatus? vitaminsAndSupplementsStatus,
  }) {
    return SupplementsViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      availableDateRanges: availableDateRanges ?? this.availableDateRanges,
      effectsOnNutrientsList:
          effectsOnNutrientsList ?? this.effectsOnNutrientsList,
      effectsOnNutrientsStatus:
          effectsOnNutrientsStatus ?? this.effectsOnNutrientsStatus,
      vitaminsAndSupplementsData:
          vitaminsAndSupplementsData ?? this.vitaminsAndSupplementsData,
      vitaminsAndSupplementsStatus:
          vitaminsAndSupplementsStatus ?? this.vitaminsAndSupplementsStatus,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        availableDateRanges,
        effectsOnNutrientsList,
        effectsOnNutrientsStatus,
        vitaminsAndSupplementsData,
        vitaminsAndSupplementsStatus,
      ];
}
