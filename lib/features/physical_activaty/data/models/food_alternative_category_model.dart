import 'package:json_annotation/json_annotation.dart';

part 'food_alternative_category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AlternativeFoodCategoryModel {
  final String type;
  final List<AlternativeFoodDetailModel> detail;

  AlternativeFoodCategoryModel({
    required this.type,
    required this.detail,
  });

  factory AlternativeFoodCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AlternativeFoodCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlternativeFoodCategoryModelToJson(this);
}

@JsonSerializable()
class AlternativeFoodDetailModel {
  final String food;
  @JsonKey(name: 'quantity_per_100g')
  final String quantityPer100g;
  final String dailyNeed;

  AlternativeFoodDetailModel({
    required this.food,
    required this.quantityPer100g,
    required this.dailyNeed,
  });

  factory AlternativeFoodDetailModel.fromJson(Map<String, dynamic> json) =>
      _$AlternativeFoodDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlternativeFoodDetailModelToJson(this);
}
