import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'organ_nutritional_effects_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrganNutritionalEffectsResponseModel extends Equatable {
  final bool success;
  final String message;
  final OrganNutritionalEffectsData data;

  const OrganNutritionalEffectsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrganNutritionalEffectsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$OrganNutritionalEffectsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrganNutritionalEffectsResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable(explicitToJson: true)
class OrganNutritionalEffectsData extends Equatable {
  final List<NutritionalEffect> effects;

  const OrganNutritionalEffectsData({required this.effects});

  factory OrganNutritionalEffectsData.fromJson(Map<String, dynamic> json) =>
      _$OrganNutritionalEffectsDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OrganNutritionalEffectsDataToJson(this);

  @override
  List<Object?> get props => [effects];
}

@JsonSerializable()
class NutritionalEffect extends Equatable {
  final String elementName;
  final String impactType;
  final String description;

  const NutritionalEffect({
    required this.elementName,
    required this.impactType,
    required this.description,
  });

  factory NutritionalEffect.fromJson(Map<String, dynamic> json) =>
      _$NutritionalEffectFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionalEffectToJson(this);

  @override
  List<Object?> get props => [elementName, impactType, description];
}
