import 'package:json_annotation/json_annotation.dart';

part 'eye_data_entry_request_body_model.g.dart';

@JsonSerializable()
class EyeDataEntryRequestBody {
  final String affectedEyePart;
  final String symptomStartDate;
  final List<String> symptoms;
  final String symptomDuration;
  final List<String> medicalProcedures;
  final String medicalReportDate;
  final List<String> medicalReportUrl;
  final List<String> medicalExaminationImages;
  final String doctorName;
  final String centerHospitalName;
  final String country;
  final String additionalNotes;
  final String writtenReport;

  EyeDataEntryRequestBody({
    required this.symptomStartDate,
    required this.affectedEyePart,
    required this.symptoms,
    required this.symptomDuration,
    required this.medicalProcedures,
    required this.medicalReportDate,
    required this.medicalReportUrl,
    required this.medicalExaminationImages,
    required this.doctorName,
    required this.centerHospitalName,
    required this.country,
    required this.additionalNotes,
    required this.writtenReport,
  });

  factory EyeDataEntryRequestBody.fromJson(Map<String, dynamic> json) =>
      _$EyeDataEntryRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EyeDataEntryRequestBodyToJson(this);
}
