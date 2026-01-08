import 'package:json_annotation/json_annotation.dart';

part 'personal_genetic_disease_request_body_model.g.dart';

@JsonSerializable()
class PersonalGeneticDiseaseRequestBodyModel {
  final String date;
  final String diseaseCategory;
  final String geneticDisease;
  final String diseaseStatus;
  @JsonKey(name: 'geneticTests')
  final List<String> firstUploadedImages;
  @JsonKey(name: 'otherTests')
  final List<String> secondUploadedImages;
  final List<String> medicalReport;
  final String doctor;
  final String hospital;
  final String country;
  final String writtenReport;

  PersonalGeneticDiseaseRequestBodyModel({
    required this.date,
    required this.writtenReport,
    required this.diseaseCategory,
    required this.geneticDisease,
    required this.diseaseStatus,
    required this.firstUploadedImages,
    required this.secondUploadedImages,
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
