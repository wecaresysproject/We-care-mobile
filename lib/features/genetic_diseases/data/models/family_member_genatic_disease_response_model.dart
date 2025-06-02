
import 'package:json_annotation/json_annotation.dart';
part 'family_member_genatic_disease_response_model.g.dart';
@JsonSerializable()
class FamilyNameGeneticDiseaseDetialsResponseModel {
  bool success;
  String message;
  @JsonKey(name: 'data')
  List<GenaticDiseaseDetails> genaticDiseaseDetails;

  FamilyNameGeneticDiseaseDetialsResponseModel({
    required this.success,
    required this.message,
    required this.genaticDiseaseDetails,
  });
  factory FamilyNameGeneticDiseaseDetialsResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$FamilyNameGeneticDiseaseDetialsResponseModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$FamilyNameGeneticDiseaseDetialsResponseModelToJson(this);
}


@JsonSerializable()
class GenaticDiseaseDetails {
  String? geneticDisease;
  String? diseaseStatuses;
  String? medicalClassification;
  String? detailedDescription;
  String? inheritanceType;
  String? responsibleGene;
  String? prevalenceRate;
  String? typicalOnsetAge;
  String? affectedGender;
  List<String>? riskLevel;
  List<String>? domainInterpretation;
  List<String>? mainSymptoms;
  List<String>? diagnosticTests;
  List<String>? availableTreatments;

  GenaticDiseaseDetails(
      {this.geneticDisease,
      this.diseaseStatuses,
      this.medicalClassification,
      this.detailedDescription,
      this.inheritanceType,
      this.responsibleGene,
      this.prevalenceRate,
      this.typicalOnsetAge,
      this.affectedGender,
      this.riskLevel,
      this.domainInterpretation,
      this.mainSymptoms,
      this.diagnosticTests,
      this.availableTreatments});
  factory GenaticDiseaseDetails.fromJson(Map<String, dynamic> json) => 
      _$GenaticDiseaseDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$GenaticDiseaseDetailsToJson(this);

}
