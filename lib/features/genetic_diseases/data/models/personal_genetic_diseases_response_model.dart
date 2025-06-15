  
import 'package:json_annotation/json_annotation.dart';

part 'personal_genetic_diseases_response_model.g.dart';
@JsonSerializable()
class PersonalGeneticDiseasesResponseModel {
  @JsonKey(name: "data")
  List<PersonalGenaticDisease>? personalGenaticDisease;

  PersonalGeneticDiseasesResponseModel({
  this.personalGenaticDisease,
  });
  factory PersonalGeneticDiseasesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$PersonalGeneticDiseasesResponseModelFromJson(json);

}

@JsonSerializable()
class PersonalGenaticDisease {
  String id;
  String geneticDisease;
  String riskLevel;
  String recommendation;


  PersonalGenaticDisease({
    required this.id,
    required this.geneticDisease,
    required this.riskLevel,
    required this.recommendation,
  });
  factory PersonalGenaticDisease.fromJson(Map<String, dynamic> json) =>
      _$PersonalGenaticDiseaseFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalGenaticDiseaseToJson(this);
}