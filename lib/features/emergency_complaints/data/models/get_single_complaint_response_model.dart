import 'package:json_annotation/json_annotation.dart';
part 'get_single_complaint_response_model.g.dart';

@JsonSerializable()
class DetailedComplaintModel {
  String id;
  String userId;
  @JsonKey(name: 'dateOfComplaintOnset')
  String data;
  List<MainSymptoms> mainSymptoms;
  String personalNote;
  SimilarComplaint similarComplaint;
  Medications medications;
  EmergencyIntervention emergencyIntervention;

  DetailedComplaintModel(
      {required this.id,
      required this.userId,
      required this.data,
      required this.mainSymptoms,
      required this.personalNote,
      required this.similarComplaint,
      required this.medications,
      required this.emergencyIntervention});

  factory DetailedComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$DetailedComplaintModelFromJson(json);
}

@JsonSerializable()
class MainSymptoms {
  @JsonKey(name: 'symptoms_LocationOfPainOrComplaint')
  String complaintbodyPart;

  String symptomsComplaint;
  String natureOfComplaint;
  String severityOfComplaint;

  MainSymptoms(
      {required this.complaintbodyPart,
      required this.symptomsComplaint,
      required this.natureOfComplaint,
      required this.severityOfComplaint});

  factory MainSymptoms.fromJson(Map<String, dynamic> json) =>
      _$MainSymptomsFromJson(json);
}

@JsonSerializable()
class SimilarComplaint {
  String diagnosis;
  String dateOfComplaint;

  SimilarComplaint({required this.diagnosis, required this.dateOfComplaint});

  factory SimilarComplaint.fromJson(Map<String, dynamic> json) =>
      _$SimilarComplaintFromJson(json);
}

@JsonSerializable()
class Medications {
  String medicationName;
  String dosage;

  Medications({required this.medicationName, required this.dosage});

  factory Medications.fromJson(Map<String, dynamic> json) =>
      _$MedicationsFromJson(json);
}

@JsonSerializable()
class EmergencyIntervention {
  String interventionType;
  String interventionDate;

  EmergencyIntervention(
      {required this.interventionType, required this.interventionDate});

  factory EmergencyIntervention.fromJson(Map<String, dynamic> json) =>
      _$EmergencyInterventionFromJson(json);
}
