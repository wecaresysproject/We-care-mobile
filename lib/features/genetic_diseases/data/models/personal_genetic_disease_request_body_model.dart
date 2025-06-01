import 'package:json_annotation/json_annotation.dart';

part 'personal_genetic_disease_request_body_model.g.dart';

@JsonSerializable()
class PersonalGeneticDiseaseRequestBodyModel {
  final String date;
  final String diseaseCategory;
  final String geneticDisease;
  final String diseaseStatus;
  @JsonKey(name: 'geneticTests')
  final String firstUploadedImage;
  @JsonKey(name: 'otherTests')
  final String secondUploadedImage;
  final String medicalReport;
  final String doctor;
  final String hospital;
  final String country;

  PersonalGeneticDiseaseRequestBodyModel({
    required this.date,
    required this.diseaseCategory,
    required this.geneticDisease,
    required this.diseaseStatus,
    required this.firstUploadedImage,
    required this.secondUploadedImage,
    required this.medicalReport,
    required this.doctor,
    required this.hospital,
    required this.country,
  });

  factory PersonalGeneticDiseaseRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$PersonalGeneticDiseaseRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PersonalGeneticDiseaseRequestBodyModelToJson(this);
}
