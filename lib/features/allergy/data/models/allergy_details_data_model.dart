import 'package:json_annotation/json_annotation.dart';

part 'allergy_details_data_model.g.dart';

@JsonSerializable()
class AllergyDetailsData {
  final String? id;
  final String allergyOccurrenceDate;
  final String allergyType;
  final List<String> allergyTriggers;
  final String? expectedSideEffects;
  final String? symptomSeverity;
  final String? timeToSymptomOnset;
  final bool? isDoctorConsulted;
  final bool? isAllergyTestPerformed;
  final String? medicationName;
  final bool? isTreatmentsEffective;
  final String? medicalReportImage;
  final String? familyHistory;
  final String? precautions;
  final String? proneToAllergies;
  final String? isMedicalWarningReceived;
  final bool? carryEpinephrine;

  AllergyDetailsData({
    this.id,
    required this.allergyOccurrenceDate,
    required this.allergyType,
    required this.allergyTriggers,
    this.expectedSideEffects,
    required this.symptomSeverity,
    required this.timeToSymptomOnset,
    required this.isDoctorConsulted,
    required this.isAllergyTestPerformed,
    this.medicationName,
    this.isTreatmentsEffective,
    this.medicalReportImage,
    this.familyHistory,
    this.precautions,
    this.proneToAllergies,
    this.isMedicalWarningReceived,
    this.carryEpinephrine,
  });

  factory AllergyDetailsData.fromJson(Map<String, dynamic> json) =>
      _$AllergyDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AllergyDetailsDataToJson(this);
}
