class NutritionDefinitionModel {
  final String elementName;
  final String definition;

  NutritionDefinitionModel({
    required this.elementName,
    required this.definition,
  });

  factory NutritionDefinitionModel.fromJson(Map<String, dynamic> json) {
    return NutritionDefinitionModel(
      elementName: json['elementName'] as String,
      definition: json['definition'] as String,
    );
  }
}
