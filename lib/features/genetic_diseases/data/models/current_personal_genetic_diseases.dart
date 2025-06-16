
import 'package:json_annotation/json_annotation.dart';

part 'current_personal_genetic_diseases.g.dart';
@JsonSerializable()
class CurrentPersonalGeneticDiseasesResponseModel {
  final String id;
  final String geneticDisease;
  final String date;
  final String diseaseStatus;
  final String country;


  CurrentPersonalGeneticDiseasesResponseModel({
    required this.id,
    required this.geneticDisease,
    required this.date,
    required this.diseaseStatus,
    required this.country,
  });
  factory CurrentPersonalGeneticDiseasesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentPersonalGeneticDiseasesResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentPersonalGeneticDiseasesResponseModelToJson(this);
}