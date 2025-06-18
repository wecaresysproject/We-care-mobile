import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_genetic_disease_detaills.g.dart';

@JsonSerializable()
class PersonalGeneticDiseasDetails {
  String? id;
  @JsonKey(name: "Date")
  String? date;
  @JsonKey(name: "DiseaseCategory")
  String? geneticDiseaseCategory;
  @JsonKey(name: "GeneticDisease")
  String? geneticDisease;
  @JsonKey(name: "DiseaseStatus")
  String? diseaseStatus;
  @JsonKey(name: "GeneticTests")
  String? geneticTestsImage;
  @JsonKey(name: "OtherTests")
  String? otherTestsImage;
  @JsonKey(name: "MedicalReport")
  String? medicalReport;
  @JsonKey(name: "Doctor")
  String? doctor;
  @JsonKey(name: "Hospital")
  String? hospital;
  @JsonKey(name: "Country")
  String? country;

  PersonalGeneticDiseasDetails(
      {this.id,
      this.date,
      this.geneticDisease,
      this.diseaseStatus,
      this.geneticTestsImage,
      this.otherTestsImage,
      this.medicalReport,
      this.doctor,
      this.hospital,
      this.country});

  factory PersonalGeneticDiseasDetails.fromJson(Map<String, dynamic> json) =>
      _$PersonalGeneticDiseasDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalGeneticDiseasDetailsToJson(this);
}
