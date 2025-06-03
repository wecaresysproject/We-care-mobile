import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';

part 'family_member_genetic_diseases_request_body_model.g.dart';

@JsonSerializable()
class FamilyMemberGeneticDiseasesRequestBodyModel {
  final String name;
  final String code;
  @JsonKey(name: 'classifications')
  final List<NewGeneticDiseaseModel> geneticDiseases;

  FamilyMemberGeneticDiseasesRequestBodyModel({
    required this.name,
    required this.code,
    required this.geneticDiseases,
  });

  factory FamilyMemberGeneticDiseasesRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$FamilyMemberGeneticDiseasesRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyMemberGeneticDiseasesRequestBodyModelToJson(this);
}
