import 'package:json_annotation/json_annotation.dart';

part 'mental_illness_model.g.dart';

@JsonSerializable()
class MentalIllnessModel {
  final String id;
  final String mentalIllnessType;
  final String diagnosisDate;
  final String duration;
  final String illnessSeverity;

  MentalIllnessModel({
    required this.id,
    required this.mentalIllnessType,
    required this.diagnosisDate,
    required this.duration,
    required this.illnessSeverity,
  });

  factory MentalIllnessModel.fromJson(Map<String, dynamic> json) =>
      _$MentalIllnessModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentalIllnessModelToJson(this);
}
