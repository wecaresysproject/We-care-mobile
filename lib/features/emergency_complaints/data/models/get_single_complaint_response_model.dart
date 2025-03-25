import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/emergency_complaints/data/models/emergency_complain_request_body.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

part 'get_single_complaint_response_model.g.dart';

@JsonSerializable()
class DetailedComplaintModel {
  String id;
  String userId;
  @JsonKey(name: 'dateOfComplaintOnset')
  String date;
  List<MedicalComplaint> mainSymptoms;
  String personalNote;
  SimilarComplaint similarComplaint;
  Medications medications;
  EmergencyIntervention emergencyIntervention;

  DetailedComplaintModel(
      {required this.id,
      required this.userId,
      required this.date,
      required this.mainSymptoms,
      required this.personalNote,
      required this.similarComplaint,
      required this.medications,
      required this.emergencyIntervention});

  factory DetailedComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$DetailedComplaintModelFromJson(json);
}
