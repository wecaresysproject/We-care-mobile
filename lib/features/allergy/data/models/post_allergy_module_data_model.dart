import 'package:json_annotation/json_annotation.dart';

part 'post_allergy_module_data_model.g.dart';

@JsonSerializable()
class PostAllergyModuleDataModel {
  final String allergyOccurrenceDate;
  final String allergyType;
  final List<String> allergyTriggers;
  final String expectedSideEffects;
  final String symptomSeverity;
  final String timeToSymptomOnset;
  final bool? isDoctorConsulted;
  final bool? isAllergyTestPerformed;
  final String medicationName;
  final bool? isTreatmentsEffective;
  final String medicalReportImage;
  final String familyHistory;
  final String precautions;
  final String proneToAllergies;
  final String isMedicalWarningReceived;
  final bool? carryEpinephrine;

  const PostAllergyModuleDataModel({
    required this.allergyOccurrenceDate,
    required this.allergyType,
    required this.allergyTriggers,
    required this.expectedSideEffects,
    required this.symptomSeverity,
    required this.timeToSymptomOnset,
    required this.isDoctorConsulted,
    required this.isAllergyTestPerformed,
    required this.medicationName,
    required this.isTreatmentsEffective,
    required this.medicalReportImage,
    required this.familyHistory,
    required this.precautions,
    required this.proneToAllergies,
    required this.isMedicalWarningReceived,
    required this.carryEpinephrine,
  });

  factory PostAllergyModuleDataModel.fromJson(Map<String, dynamic> json) =>
      _$PostAllergyModuleDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostAllergyModuleDataModelToJson(this);
}
