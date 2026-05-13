import 'package:json_annotation/json_annotation.dart';

part 'vaccine_request_body_model.g.dart';

@JsonSerializable()
class VaccineModuleRequestBody {
  @JsonKey(name: 'date')
  final String date;
  @JsonKey(name: 'TargetAge')
  final String targetAge;
  @JsonKey(name: 'VaccineName')
  final String vaccineName;
  @JsonKey(name: 'Generation')
  final String generation;
  @JsonKey(name: 'VaccineCategory')
  final String vaccineCategory;
  @JsonKey(name: 'PerfectAge')
  final String perfectAge;
  @JsonKey(name: 'AbbreviationCode')
  final String abbreviationCode;
  @JsonKey(name: 'VaccineActionDescription')
  final String vaccineActionDescription;
  @JsonKey(name: 'PriorityTake')
  final String priorityTake;
  @JsonKey(name: 'TargetDisease')
  final String targetDisease;
  @JsonKey(name: 'Dose')
  final String dose;
  @JsonKey(name: 'WayToTakeVaccine')
  final String wayToTakeVaccine;
  @JsonKey(name: 'VaccinationProvider')
  final String vaccinationProvider;
  @JsonKey(name: 'Country')
  final String country;
  @JsonKey(name: 'AdditionalInfo')
  final String? additionalInfo;

  VaccineModuleRequestBody({
    required this.date,
    required this.targetAge,
    required this.vaccineName,
    required this.generation,
    required this.vaccineCategory,
    required this.perfectAge,
    required this.abbreviationCode,
    required this.vaccineActionDescription,
    required this.priorityTake,
    required this.targetDisease,
    required this.dose,
    required this.wayToTakeVaccine,
    required this.vaccinationProvider,
    required this.country,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() => _$VaccineModuleRequestBodyToJson(this);
}
