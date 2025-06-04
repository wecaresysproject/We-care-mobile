

import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_genetic_disease_detaills.g.dart';
@JsonSerializable()
class PersonalGeneticDiseasDetails {
  String? id;
  String? date;
  String? geneticDisease;
  String? diseaseStatus;
  String? geneticTestsImage;
  String? otherTestsImage;
  String? medicalReport;
  String? doctor;
  String? hospital;
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
