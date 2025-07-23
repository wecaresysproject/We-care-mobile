import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

part 'mental_illness_request_body.g.dart';

@JsonSerializable()
class MentalIllnessRequestBody {
  final String diagnosisDate;
  final String mentalIllnessType;
  final String selectedMedicalSymptom;
  final List<MedicalComplaint> medicalSymptomsList;
  final String illnessSeverity;
  final String illnessDuration;
  final ImpactfulIncident hasImpactfulIncident;
  final FamilyMentalIllness hasFamilySimilarMentalIllnessCases;
  @JsonKey(name: 'psychologicalEmergencies')
  final String selectedPsychologicalEmergencies;
  final String socialSupport;
  @JsonKey(name: 'medicationSideEffects')
  final String selectedMedicationSideEffects;
  final String preferredActivitiesForImprovement;
  final PsychologicalTreatment isReceivingPsychologicalTreatment;

  MentalIllnessRequestBody({
    required this.diagnosisDate,
    required this.mentalIllnessType,
    required this.selectedMedicalSymptom,
    required this.medicalSymptomsList,
    required this.illnessSeverity,
    required this.illnessDuration,
    required this.hasImpactfulIncident,
    required this.hasFamilySimilarMentalIllnessCases,
    required this.selectedPsychologicalEmergencies,
    required this.socialSupport,
    required this.selectedMedicationSideEffects,
    required this.preferredActivitiesForImprovement,
    required this.isReceivingPsychologicalTreatment,
  });

  factory MentalIllnessRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MentalIllnessRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$MentalIllnessRequestBodyToJson(this);
}

@JsonSerializable()
class ImpactfulIncident {
  final bool? answer;
  final String? incidentType;
  final String? incidentDate;
  final String? incidentPsychologicalImpact;

  ImpactfulIncident({
    required this.answer,
    required this.incidentType,
    required this.incidentDate,
    required this.incidentPsychologicalImpact,
  });

  factory ImpactfulIncident.fromJson(Map<String, dynamic> json) =>
      _$ImpactfulIncidentFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactfulIncidentToJson(this);
}

@JsonSerializable()
class FamilyMentalIllness {
  final bool? answer;
  final String? relationship;

  FamilyMentalIllness({
    required this.answer,
    required this.relationship,
  });

  factory FamilyMentalIllness.fromJson(Map<String, dynamic> json) =>
      _$FamilyMentalIllnessFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyMentalIllnessToJson(this);
}

@JsonSerializable()
class PsychologicalTreatment {
  final bool? answer;
  final String? medicationsUsed;
  final String? medicationEffectOnDailyLife;
  final String? previousTherapyType;
  final int? numberOfSessions;
  final String? therapySatisfaction;
  final String? doctorOrSpecialist;
  final String? hospitalOrCenter;
  final String? country;

  PsychologicalTreatment({
    required this.answer,
    required this.medicationsUsed,
    required this.medicationEffectOnDailyLife,
    required this.previousTherapyType,
    required this.numberOfSessions,
    required this.therapySatisfaction,
    required this.doctorOrSpecialist,
    required this.hospitalOrCenter,
    required this.country,
  });

  factory PsychologicalTreatment.fromJson(Map<String, dynamic> json) =>
      _$PsychologicalTreatmentFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologicalTreatmentToJson(this);
}
