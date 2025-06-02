import 'package:json_annotation/json_annotation.dart';

part 'family_member_genatics_diseases_response_model.g.dart';

@JsonSerializable()
class FamilyMemberGeneticsDiseasesResponseModel {
  @JsonKey(name: 'code')
  String familyMemberCode;
  @JsonKey(name: 'name')
  String familyMemberName;
  @JsonKey(name: 'classifications')
  List<GeneticDisease>? geneticDiseases;

  FamilyMemberGeneticsDiseasesResponseModel({
    required this.familyMemberCode,
    required this.familyMemberName,
    this.geneticDiseases,
  });

  factory FamilyMemberGeneticsDiseasesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$FamilyMemberGeneticsDiseasesResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyMemberGeneticsDiseasesResponseModelToJson(this);
}

@JsonSerializable()
class GeneticDisease{

  String geneticDisease;
  String inheritanceType;
  String diseaseStatus;

  GeneticDisease({
    required this.geneticDisease,
    required this.inheritanceType,
    required this.diseaseStatus,
  });

  factory GeneticDisease.fromJson(Map<String, dynamic> json) =>
      _$GeneticDiseaseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneticDiseaseToJson(this);
}