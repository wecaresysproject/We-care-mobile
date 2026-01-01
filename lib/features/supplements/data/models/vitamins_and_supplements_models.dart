import 'package:json_annotation/json_annotation.dart';

part 'vitamins_and_supplements_models.g.dart';

@JsonSerializable()
class SupplementModel {
  final String name;

  SupplementModel({required this.name});

  factory SupplementModel.fromJson(Map<String, dynamic> json) =>
      _$SupplementModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplementModelToJson(this);
}

@JsonSerializable()
class ElementValueModel {
  final String name;
  final String amount;

  ElementValueModel({
    required this.name,
    required this.amount,
  });

  factory ElementValueModel.fromJson(Map<String, dynamic> json) =>
      _$ElementValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElementValueModelToJson(this);
}

@JsonSerializable()
class ElementComparisonModel {
  final String elementName;
  final List<ElementValueModel> values;

  ElementComparisonModel({
    required this.elementName,
    required this.values,
  });

  factory ElementComparisonModel.fromJson(Map<String, dynamic> json) =>
      _$ElementComparisonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElementComparisonModelToJson(this);
}

@JsonSerializable()
class VitaminsAndSupplementsModel {
  final List<SupplementModel> supplements;
  final List<ElementComparisonModel> elements;

  VitaminsAndSupplementsModel({
    required this.supplements,
    required this.elements,
  });

  factory VitaminsAndSupplementsModel.fromJson(Map<String, dynamic> json) =>
      _$VitaminsAndSupplementsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitaminsAndSupplementsModelToJson(this);
}
