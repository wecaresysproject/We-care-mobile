import 'package:json_annotation/json_annotation.dart';

part 'update_nutrition_value_model.g.dart';

@JsonSerializable()
class UpdateNutritionValueModel {
  final double newStandard;

  UpdateNutritionValueModel({required this.newStandard});

  Map<String, dynamic> toJson() => _$UpdateNutritionValueModelToJson(this);
}
