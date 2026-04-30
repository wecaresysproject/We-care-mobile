import 'package:json_annotation/json_annotation.dart';

part 'vaccine_details_model.g.dart';

@JsonSerializable()
class VaccineDetailsModel {
  @JsonKey(name: 'vaccineCategory')
  final String? vaccineCategory;
  @JsonKey(name: 'perfectAge')
  final String? recommendedAge;
  final String? abbreviationCode;
  @JsonKey(name: 'vaccineActionDescription')
  final String? description;
  @JsonKey(name: 'priorityTake')
  final String? priorityTake; // Mandatory / Optional
  @JsonKey(name: 'targetDisease')
  final String? targetDisease;
  final String? dose;
  @JsonKey(name: 'wayToTakeVaccine')
  final String? administrationMethod;

  VaccineDetailsModel({
    this.vaccineCategory,
    this.recommendedAge,
    this.abbreviationCode,
    this.description,
    this.priorityTake,
    this.targetDisease,
    this.dose,
    this.administrationMethod,
  });

  factory VaccineDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VaccineDetailsModelFromJson(json);
}
