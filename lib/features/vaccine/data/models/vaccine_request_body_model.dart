import 'package:json_annotation/json_annotation.dart';

part 'vaccine_request_body_model.g.dart';

@JsonSerializable()
class VaccineModuleRequestBody {
  final String vaccineName;
  final String vaccineDate;
  final String vaccineCategory;
  final String vaccinePerfectAge;
  final String dose;
  final String regionForVaccine;
  final String country;
  final String? notes;

  VaccineModuleRequestBody({
    required this.vaccineName,
    required this.vaccineDate,
    required this.vaccineCategory,
    required this.vaccinePerfectAge,
    required this.dose,
    required this.regionForVaccine,
    required this.country,
    this.notes,
  });

  Map<String, dynamic> toJson() => _$VaccineModuleRequestBodyToJson(this);
}
