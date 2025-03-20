import 'package:json_annotation/json_annotation.dart';

part 'vaccine_model.g.dart';

@JsonSerializable()
class VaccineModel {
  final String vaccineName;
  final String vaccinePerfectAge;
  final String ageSection;
  @JsonKey(name: 'dose')
  final List<String> doses;
  final String doseDaily;
  final String diseases;
  final String wayToTakeVaccine;

  VaccineModel({
    required this.vaccineName,
    required this.vaccinePerfectAge,
    required this.ageSection,
    required this.doses,
    required this.doseDaily,
    required this.diseases,
    required this.wayToTakeVaccine,
  });

  // From JSON
  factory VaccineModel.fromJson(Map<String, dynamic> json) =>
      _$VaccineModelFromJson(json);
}
