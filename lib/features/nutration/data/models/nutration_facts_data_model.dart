import 'package:json_annotation/json_annotation.dart';

part 'nutration_facts_data_model.g.dart';

@JsonSerializable()
class NutrationFactsModel {
  final double calories;
  final double protein;
  final double saturatedFats;
  final double monounsaturatedFats;
  final double polyunsaturatedFats;
  final double totalFats;
  final double cholesterol;
  final double carbohydrates;
  final double fiber;
  final double sugars;
  final double sodium;
  final double potassium;
  final double calcium;
  final double iron;
  final double magnesium;
  final double zinc;
  final double copper;
  final double phosphorus;
  final double manganese;
  final double seleniumMcg;
  final double iodineMcg;
  final double vitaminAMcg;
  final double vitaminDMcg;
  final double vitaminEMg;
  final double vitaminKMcg;
  final double vitaminCMg;
  final double vitaminB1Mg;
  final double vitaminB2Mg;
  final double vitaminB3Mg;
  final double vitaminB6Mg;
  final double folateMcg;
  final double vitaminB12Mcg;
  final double cholineMg;
  final double waterL;

  const NutrationFactsModel({
    required this.calories,
    required this.protein,
    required this.saturatedFats,
    required this.monounsaturatedFats,
    required this.polyunsaturatedFats,
    required this.totalFats,
    required this.cholesterol,
    required this.carbohydrates,
    required this.fiber,
    required this.sugars,
    required this.sodium,
    required this.potassium,
    required this.calcium,
    required this.iron,
    required this.magnesium,
    required this.zinc,
    required this.copper,
    required this.phosphorus,
    required this.manganese,
    required this.seleniumMcg,
    required this.iodineMcg,
    required this.vitaminAMcg,
    required this.vitaminDMcg,
    required this.vitaminEMg,
    required this.vitaminKMcg,
    required this.vitaminCMg,
    required this.vitaminB1Mg,
    required this.vitaminB2Mg,
    required this.vitaminB3Mg,
    required this.vitaminB6Mg,
    required this.folateMcg,
    required this.vitaminB12Mcg,
    required this.cholineMg,
    required this.waterL,
  });

  factory NutrationFactsModel.fromJson(Map<String, dynamic> json) =>
      _$NutrationFactsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutrationFactsModelToJson(this);
}
