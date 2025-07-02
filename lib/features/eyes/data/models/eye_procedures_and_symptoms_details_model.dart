import 'package:json_annotation/json_annotation.dart';

part 'eye_procedures_and_symptoms_details_model.g.dart';

@JsonSerializable()
class EyeProceduresAndSymptomsDetailsModel {
  final String id;
  final String symptomStartDate;
  final List<String> symptoms;
  final String symptomDuration;
  final String medicalReportDate;
  final List<String> medicalProcedures;
  final String affectedEyePart;
  final String medicalReportUrl;
  final String medicalExaminationImages;
  final String doctorName;
  final String centerHospitalName;
  final String country;
  final String additionalNotes;

  EyeProceduresAndSymptomsDetailsModel({
    required this.id,
    required this.symptomStartDate,
    required this.symptoms,
    required this.symptomDuration,
    required this.medicalReportDate,
    required this.medicalProcedures,
    required this.affectedEyePart,
    required this.medicalReportUrl,
    required this.medicalExaminationImages,
    required this.doctorName,
    required this.centerHospitalName,
    required this.country,
    required this.additionalNotes,
  });

  factory EyeProceduresAndSymptomsDetailsModel.fromJson(
          Map<String, dynamic> json) =>
      _$EyeProceduresAndSymptomsDetailsModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EyeProceduresAndSymptomsDetailsModelToJson(this);
}
