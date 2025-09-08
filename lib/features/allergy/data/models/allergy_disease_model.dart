import 'package:json_annotation/json_annotation.dart';

part 'allergy_disease_model.g.dart';

@JsonSerializable()
class AllergyDiseaseModel {
  final String allergyType;
  final String allergyOccurrenceDate;
  final List<String> allergyTriggers;
  final String symptomSeverity;
  final String precautions;
  final String id;

  AllergyDiseaseModel({
    required this.allergyType,
    required this.allergyOccurrenceDate,
    required this.allergyTriggers,
    required this.symptomSeverity,
    required this.precautions,
    required this.id,
  });

  /// fromJson
  factory AllergyDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$AllergyDiseaseModelFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$AllergyDiseaseModelToJson(this);
}
