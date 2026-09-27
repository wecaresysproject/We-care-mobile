import 'package:json_annotation/json_annotation.dart';

part 'experience_model.g.dart';

@JsonSerializable()
class ExperienceModel {
  final String position;
  final String workPlace;
  final String fromDate;
  final String toDate;
  final String countryName;

  ExperienceModel({
    required this.position,
    required this.workPlace,
    required this.fromDate,
    required this.toDate,
    required this.countryName,
  });

  Map<String, dynamic> toJson() => _$ExperienceModelToJson(this);
}
