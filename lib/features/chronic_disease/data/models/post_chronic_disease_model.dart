import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';

part 'post_chronic_disease_model.g.dart';

@JsonSerializable()
class PostChronicDiseaseModel {
  final String diagnosisStartDate;
  final String diseaseName;
  final List<AddNewMedicineModel> medications;
  final String treatingDoctorName;
  final String diseaseStatus;
  final String sideEffect;
  final String personalNotes;

  PostChronicDiseaseModel({
    required this.diagnosisStartDate,
    required this.diseaseName,
    required this.medications,
    required this.treatingDoctorName,
    required this.diseaseStatus,
    required this.sideEffect,
    required this.personalNotes,
  });

  factory PostChronicDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$PostChronicDiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostChronicDiseaseModelToJson(this);
}
