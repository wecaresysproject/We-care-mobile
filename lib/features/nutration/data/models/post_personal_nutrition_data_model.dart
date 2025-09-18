import 'package:json_annotation/json_annotation.dart';

part 'post_personal_nutrition_data_model.g.dart';

@JsonSerializable()
class PostPersonalNutritionData {
  final int weight;
  final int height;
  final int age;
  final String gender;
  final String physicalActivity;
  final List<String>? chronicDisease;

  PostPersonalNutritionData({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.physicalActivity,
    required this.chronicDisease,
  });

  factory PostPersonalNutritionData.fromJson(Map<String, dynamic> json) =>
      _$PostPersonalNutritionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostPersonalNutritionDataToJson(this);
}
