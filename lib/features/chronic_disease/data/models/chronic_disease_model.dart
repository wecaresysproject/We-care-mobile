import 'package:json_annotation/json_annotation.dart';

part 'chronic_disease_model.g.dart';

@JsonSerializable()
class ChronicDiseaseModel {
  /// عنوان المرض
  final String title;

  final String id;

  /// تاريخ بداية التشخيص
  final String diagnosisStartDate;

  /// الطبيب المتابع
  final String treatingDoctorName;

  /// حالة المرض
  final String diseaseStatus;

  ChronicDiseaseModel({
    required this.title,
    required this.id,
    required this.diagnosisStartDate,
    required this.treatingDoctorName,
    required this.diseaseStatus,
  });

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$ChronicDiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChronicDiseaseModelToJson(this);
}
