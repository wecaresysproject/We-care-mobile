import 'package:json_annotation/json_annotation.dart';

part 'single_nutrient_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SingleNutrientModel {
  @JsonKey(name: 'total')
  final double totalNutrientIntake;

  @JsonKey(name: 'data')
  final List<NutrientItem> items;

  SingleNutrientModel({
    required this.totalNutrientIntake,
    required this.items,
  });

  factory SingleNutrientModel.fromJson(Map<String, dynamic> json) =>
      _$SingleNutrientModelFromJson(json);

  Map<String, dynamic> toJson() => _$SingleNutrientModelToJson(this);
}

@JsonSerializable()
class NutrientItem {
  @JsonKey(name: 'foodName')
  final String name;

  final String servingSize;

  final String amount;

  @JsonKey(name: 'value')
  final double nutrientIntake;

  NutrientItem({
    required this.name,
    required this.servingSize,
    required this.amount,
    required this.nutrientIntake,
  });

  factory NutrientItem.fromJson(Map<String, dynamic> json) =>
      _$NutrientItemFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientItemToJson(this);
}
