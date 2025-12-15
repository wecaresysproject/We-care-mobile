import 'package:json_annotation/json_annotation.dart';

part 'nutration_facts_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NutrationFactsModel {
  String userDietplan;
  final List<FoodItemModel> foodItems;

  NutrationFactsModel({
    required this.userDietplan,
    required this.foodItems,
  });

  factory NutrationFactsModel.fromJson(Map<String, dynamic> json) =>
      _$NutrationFactsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutrationFactsModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FoodItemModel {
  final String foodName;
  final String servingSize;
  final String mainIngredient;
  final double amount;
  final String unit;
  final String analysisMethod;
  final String recipeSource;
  final String usdaFdcId;
  final String usdaDescription;

  // 34 عنصر غذائي
  final double calories;
  final double protein;
  final double totalFat;
  final double saturatedFats;
  final double monounsaturatedFats;
  final double polyunsaturatedFats;
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

  FoodItemModel({
    required this.foodName,
    required this.servingSize,
    required this.mainIngredient,
    required this.amount,
    required this.unit,
    required this.analysisMethod,
    required this.recipeSource,
    required this.usdaFdcId,
    required this.usdaDescription,
    required this.calories,
    required this.protein,
    required this.totalFat,
    required this.saturatedFats,
    required this.monounsaturatedFats,
    required this.polyunsaturatedFats,
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

  factory FoodItemModel.fromJson(Map<String, dynamic> json) =>
      _$FoodItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemModelToJson(this);
}
