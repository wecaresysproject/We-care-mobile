import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_segmentation_model.g.dart';

@JsonSerializable()
class MealSegmentationModel extends Equatable {
  @JsonKey(name: 'meal_count')
  final int mealCount;
  @JsonKey(name: 'meals')
  final List<String> meals;

  const MealSegmentationModel({
    required this.mealCount,
    required this.meals,
  });

  factory MealSegmentationModel.fromJson(Map<String, dynamic> json) =>
      _$MealSegmentationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealSegmentationModelToJson(this);

  @override
  List<Object?> get props => [mealCount, meals];
}
