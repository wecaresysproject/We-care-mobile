import 'package:json_annotation/json_annotation.dart';

part 'allergy_disease_model.g.dart';

@JsonSerializable()
class AllergyDiseaseModel {
  final String title;
  final String date;
  final List<String> causes;
  final String severity;
  final String precautions;
  final String id;

  AllergyDiseaseModel({
    required this.title,
    required this.date,
    required this.causes,
    required this.severity,
    required this.precautions,
    required this.id,
  });

  /// fromJson
  factory AllergyDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$AllergyDiseaseModelFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$AllergyDiseaseModelToJson(this);
}
