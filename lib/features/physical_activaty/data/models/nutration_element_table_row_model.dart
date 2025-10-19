import 'package:json_annotation/json_annotation.dart';

part 'nutration_element_table_row_model.g.dart';

@JsonSerializable()
class NutritionElement {
  @JsonKey(name: 'nutrient')
  final String elementName;
  @JsonKey(name: 'actual')
  final int? dailyActual;
  @JsonKey(name: 'standard')
  final int? dailyStandard;

  final int? accumulativeActual;
  final int? accumulativeStandard;
  final int? difference;

  NutritionElement({
    required this.elementName,
    required this.dailyActual,
    required this.dailyStandard,
    required this.accumulativeActual,
    required this.accumulativeStandard,
    required this.difference,
  });

  /// Factory method to create object from JSON
  factory NutritionElement.fromJson(Map<String, dynamic> json) =>
      _$NutritionElementFromJson(json);

  /// Method to convert object to JSON
  Map<String, dynamic> toJson() => _$NutritionElementToJson(this);
}
