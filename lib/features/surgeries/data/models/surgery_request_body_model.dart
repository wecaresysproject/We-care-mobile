import 'package:json_annotation/json_annotation.dart';

part 'surgery_request_body_model.g.dart';

@JsonSerializable()
class SurgeryRequestBodyModel {
  final String surgeryDate;
  final String surgeryRegion;
  final String subSurgeryRegion;
  final String surgeryName;
  final String usedTechnique;
  final String surgeryDescription;
  final String medicalReportImage;
  final String surgeryStatus;
  final String hospitalCenter;
  final String surgeonName;
  final String anesthesiologistName;
  final String postSurgeryInstructions;
  final String country;
  final String additionalNotes;

  const SurgeryRequestBodyModel({
    required this.surgeryDate,
    required this.surgeryRegion,
    required this.subSurgeryRegion,
    required this.surgeryName,
    required this.usedTechnique,
    required this.surgeryDescription,
    required this.medicalReportImage,
    required this.surgeryStatus,
    required this.hospitalCenter,
    required this.surgeonName,
    required this.anesthesiologistName,
    required this.postSurgeryInstructions,
    required this.country,
    required this.additionalNotes,
  });

  Map<String, dynamic> toJson() => _$SurgeryRequestBodyModelToJson(this);
}
