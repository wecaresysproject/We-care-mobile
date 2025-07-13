import 'package:json_annotation/json_annotation.dart';

part 'mental_illness_model.g.dart';

@JsonSerializable()
class MentalIllnessModel {
  final String title;
  final String date;
  final String duration;
  final String severity; // شدة المرض

  MentalIllnessModel({
    required this.title,
    required this.date,
    required this.duration,
    required this.severity,
  });

  factory MentalIllnessModel.fromJson(Map<String, dynamic> json) =>
      _$MentalIllnessModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentalIllnessModelToJson(this);
}
