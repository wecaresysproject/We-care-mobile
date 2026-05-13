import 'package:json_annotation/json_annotation.dart';

part 'effects_on_nutrients_model.g.dart';

@JsonSerializable()
class EffectsOnNutrientsModel {
  final String? nutrient;
  final double? standard;
  final double? accumulativeStandard;
  final double? difference;
  final double? amountFromVitamins;
  final double? differenceAfterVitamins;

  EffectsOnNutrientsModel({
    this.nutrient,
    this.standard,
    this.accumulativeStandard,
    this.difference,
    this.amountFromVitamins,
    this.differenceAfterVitamins,
  });

  factory EffectsOnNutrientsModel.fromJson(Map<String, dynamic> json) =>
      _$EffectsOnNutrientsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EffectsOnNutrientsModelToJson(this);
}
