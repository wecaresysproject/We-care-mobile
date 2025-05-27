import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_genetic_disease_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class NewGeneticDiseaseModel {
  @HiveField(0)
  final String? diseaseCategory; // فئة المرض
  @HiveField(1)
  final String? geneticDisease; // المرض الوراثي
  @HiveField(2)
  final String? appearanceAgeStage; //  مرحلة ظهور المرض
  @HiveField(3)
  final String? patientStatus; // حالة المريض

  NewGeneticDiseaseModel({
    required this.diseaseCategory,
    required this.geneticDisease,
    required this.appearanceAgeStage,
    required this.patientStatus,
  });

  /// JSON serialization
  factory NewGeneticDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$NewGeneticDiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewGeneticDiseaseModelToJson(this);

  NewGeneticDiseaseModel updateWith({
    String? diseaseCategory,
    String? geneticDisease,
    String? appearanceAgeStage,
    String? patientStatus,
  }) {
    return NewGeneticDiseaseModel(
      diseaseCategory: diseaseCategory ?? this.diseaseCategory,
      geneticDisease: geneticDisease ?? this.geneticDisease,
      appearanceAgeStage: appearanceAgeStage ?? this.appearanceAgeStage,
      patientStatus: patientStatus ?? this.patientStatus,
    );
  }
}
