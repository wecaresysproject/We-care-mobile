import 'package:json_annotation/json_annotation.dart';

part 'single_nutrient_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SingleNutrientModel {
  final List<NutrientItem> items;
  @JsonKey(name: "total_nutrient_intake")
  final double totalNutrientIntake;

  SingleNutrientModel({
    required this.items,
    required this.totalNutrientIntake,
  });

  factory SingleNutrientModel.fromJson(Map<String, dynamic> json) =>
      _$SingleNutrientModelFromJson(json);

  Map<String, dynamic> toJson() => _$SingleNutrientModelToJson(this);
}

@JsonSerializable()
class NutrientItem {
  final String name;

  @JsonKey(name: "quantity_grams")
  final double quantityGrams;

  @JsonKey(name: "nutrient_per_100g")
  final double nutrientPer100g;

  @JsonKey(name: "nutrient_intake")
  final double nutrientIntake;

  NutrientItem({
    required this.name,
    required this.quantityGrams,
    required this.nutrientPer100g,
    required this.nutrientIntake,
  });

  factory NutrientItem.fromJson(Map<String, dynamic> json) =>
      _$NutrientItemFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientItemToJson(this);
}
