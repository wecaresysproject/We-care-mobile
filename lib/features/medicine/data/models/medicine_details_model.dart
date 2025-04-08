import 'package:json_annotation/json_annotation.dart';

part 'medicine_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicineDetailsModel {
  final String id;
  final String tradeName;
  final String scientificName;
  final List<MedicalForm> medicalForms;
  final String dosageFrequency;
  final String doseUsageCategory;
  final String usageDuration;
  final List<String> conflictingMedications;

  MedicineDetailsModel({
    required this.id,
    required this.tradeName,
    required this.scientificName,
    required this.medicalForms,
    required this.dosageFrequency,
    required this.doseUsageCategory,
    required this.usageDuration,
    required this.conflictingMedications,
  });

  factory MedicineDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineDetailsModelToJson(this);
}

@JsonSerializable()
class MedicalForm {
  final String form;
  final List<String> examples;
  final List<String> doses;

  MedicalForm({
    required this.form,
    required this.examples,
    required this.doses,
  });

  factory MedicalForm.fromJson(Map<String, dynamic> json) =>
      _$MedicalFormFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalFormToJson(this);
}
