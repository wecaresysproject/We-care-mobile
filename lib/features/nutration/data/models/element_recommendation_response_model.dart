import 'package:json_annotation/json_annotation.dart';

part 'element_recommendation_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ElementRecommendationResponseModel {
  final String status;
  final ElementData data;

  ElementRecommendationResponseModel({
    required this.status,
    required this.data,
  });

  factory ElementRecommendationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ElementRecommendationResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ElementRecommendationResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ElementData {
  @JsonKey(name: 'quick_overview')
  final String quickOverview;

  @JsonKey(name: 'safe_level')
  final String safeLevel;

  @JsonKey(name: 'risk_levels')
  final RiskLevels riskLevels;

  @JsonKey(name: 'organ_effects_over_time')
  final List<EffectItem> organEffectsOverTime;

  @JsonKey(name: 'supplementary_information')
  final List<EffectItem> supplementaryInformation;

  final List<String> references;

  ElementData({
    required this.quickOverview,
    required this.safeLevel,
    required this.riskLevels,
    required this.organEffectsOverTime,
    required this.supplementaryInformation,
    required this.references,
  });

  factory ElementData.fromJson(Map<String, dynamic> json) =>
      _$ElementDataFromJson(json);

  Map<String, dynamic> toJson() => _$ElementDataToJson(this);
}

@JsonSerializable()
class RiskLevels {
  final bool isHighRiskLevel;

  @JsonKey(name: 'indicator_value')
  final String indicatorValue;

  final List<Risk> risks;

  RiskLevels({
    required this.isHighRiskLevel,
    required this.indicatorValue,
    required this.risks,
  });

  factory RiskLevels.fromJson(Map<String, dynamic> json) =>
      _$RiskLevelsFromJson(json);

  Map<String, dynamic> toJson() => _$RiskLevelsToJson(this);
}

@JsonSerializable()
class Risk {
  final String title;
  final String description;

  Risk({
    required this.title,
    required this.description,
  });

  factory Risk.fromJson(Map<String, dynamic> json) => _$RiskFromJson(json);

  Map<String, dynamic> toJson() => _$RiskToJson(this);
}

@JsonSerializable()
class EffectItem {
  final String title;
  final String description;

  EffectItem({
    required this.title,
    required this.description,
  });

  factory EffectItem.fromJson(Map<String, dynamic> json) =>
      _$EffectItemFromJson(json);

  Map<String, dynamic> toJson() => _$EffectItemToJson(this);
}
