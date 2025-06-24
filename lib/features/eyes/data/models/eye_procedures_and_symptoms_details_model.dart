import 'package:json_annotation/json_annotation.dart';

part 'eye_procedures_and_symptoms_details_model.g.dart';
@JsonSerializable()
class EyeProceduresAndSymptomsDetailsModel {
  final String id;
  final String symptomStartDate;
  final List<String> symptoms;
  final String symptomDuration;
  final String procedureDate;
  final List<String> procedures;
  final String medicalReportText;
  final String medicalReportImage;
  final String medicalExaminationImage;
  final String doctorName;
  final String hospitalName;
  final String country;
  final String notes;

  EyeProceduresAndSymptomsDetailsModel({
    required this.id,
    required this.symptomStartDate,
    required this.symptoms,
    required this.symptomDuration,
    required this.procedureDate,
    required this.procedures,
    required this.medicalReportText,
    required this.medicalReportImage,
    required this.medicalExaminationImage,
    required this.doctorName,
    required this.hospitalName,
    required this.country,
    required this.notes,
  });

  factory EyeProceduresAndSymptomsDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$EyeProceduresAndSymptomsDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeProceduresAndSymptomsDetailsModelToJson(this);
}
