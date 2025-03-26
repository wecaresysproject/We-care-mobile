import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

part 'emergency_complain_request_body.g.dart';

@JsonSerializable(explicitToJson: true)
class EmergencyComplainRequestBody {
  @JsonKey(name: 'dateOfComplaintOnset')
  final String dateOfComplaint;
  @JsonKey(name: 'mainSymptoms')
  final List<MedicalComplaint> userMedicalComplaint;
  final String? personalNote;
  final SimilarComplaint? similarComplaint;
  @JsonKey(name: 'medications')
  final Medications? medication;
  final EmergencyIntervention? emergencyIntervention;

  EmergencyComplainRequestBody({
    required this.dateOfComplaint,
    required this.userMedicalComplaint,
    this.personalNote,
    this.similarComplaint,
    this.medication,
    this.emergencyIntervention,
  });

  factory EmergencyComplainRequestBody.fromJson(Map<String, dynamic> json) =>
      _$EmergencyComplainRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyComplainRequestBodyToJson(this);
}

@JsonSerializable()
class SimilarComplaint {
  final String diagnosis;
  final String dateOfComplaint;

  SimilarComplaint({
    required this.diagnosis,
    required this.dateOfComplaint,
  });

  factory SimilarComplaint.fromJson(Map<String, dynamic> json) =>
      _$SimilarComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$SimilarComplaintToJson(this);
}

@JsonSerializable()
class Medications {
  final String medicationName;
  final String dosage;

  Medications({
    required this.medicationName,
    required this.dosage,
  });

  factory Medications.fromJson(Map<String, dynamic> json) =>
      _$MedicationsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationsToJson(this);
}

@JsonSerializable()
class EmergencyIntervention {
  final String interventionType;
  final String interventionDate;

  EmergencyIntervention({
    required this.interventionType,
    required this.interventionDate,
  });

  factory EmergencyIntervention.fromJson(Map<String, dynamic> json) =>
      _$EmergencyInterventionFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyInterventionToJson(this);
}
