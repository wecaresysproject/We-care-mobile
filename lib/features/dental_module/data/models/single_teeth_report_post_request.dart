import 'package:json_annotation/json_annotation.dart';

part 'single_teeth_report_post_request.g.dart';

@JsonSerializable()
final class SingleTeethReportRequestBody {
  @JsonKey(name: 'SymptomStartDate')
  final String symptomStartDate;
  @JsonKey(name: 'SymptomType')
  final String symptomType;
  @JsonKey(name: 'SymptomDuration')
  final String symptomDuration;
  @JsonKey(name: 'ComplaintNature')
  final String complaintNature;
  @JsonKey(name: 'painNature')
  final String complaintDegree;
  @JsonKey(name: 'TeethNumber')
  final String teethNumber;
  @JsonKey(name: 'ProcedureDate')
  final String procedureDate;
  @JsonKey(name: 'PrimaryProcedure')
  final String primaryProcedure;
  @JsonKey(name: 'SubProcedure')
  final String subProcedure;
  @JsonKey(name: 'MedicalReportImage')
  final List<String> medicalReportImage;
  @JsonKey(name: 'XRayImage')
  final List<String> xRayImage;
  @JsonKey(name: 'LymphAnalysis')
  final String lymphAnalysis;
  @JsonKey(name: 'LymphAnalysisImage')
  final List<String> lymphAnalysisImage;
  @JsonKey(name: 'GumCondition')
  final String gumCondition;
  @JsonKey(name: 'TreatingDoctor')
  final String treatingDoctor;
  @JsonKey(name: 'Hospital')
  final String? hospital;
  @JsonKey(name: 'Country')
  final String country;
  @JsonKey(name: 'AdditionalNotes')
  final String additionalNotes;
  final String writtenReport;
  final String? dentalCenter;

  const SingleTeethReportRequestBody({
    required this.symptomStartDate,
    required this.symptomType,
    required this.symptomDuration,
    required this.complaintNature,
    required this.complaintDegree,
    required this.teethNumber,
    required this.procedureDate,
    required this.primaryProcedure,
    required this.subProcedure,
    required this.medicalReportImage,
    required this.xRayImage,
    required this.lymphAnalysis,
    required this.lymphAnalysisImage,
    required this.gumCondition,
    required this.treatingDoctor,
    required this.hospital,
    required this.country,
    required this.additionalNotes,
    required this.writtenReport,
    required this.dentalCenter,
  });

  factory SingleTeethReportRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SingleTeethReportRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SingleTeethReportRequestBodyToJson(this);
}
