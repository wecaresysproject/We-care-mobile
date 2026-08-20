import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_vaccine_details_response_model.g.dart';

/// Response of `GET /Vaccine/vaccine-user-entry?id=<documentId>` — the full
/// record behind a row of the user's vaccines table.
@JsonSerializable()
class GetVaccineDetailsResponseModel extends Equatable {
  final bool success;
  final String message;
  @JsonKey(name: 'data')
  final VaccineUserEntryDetailsModel? vaccineDetails;

  const GetVaccineDetailsResponseModel({
    required this.success,
    required this.message,
    this.vaccineDetails,
  });

  factory GetVaccineDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetVaccineDetailsResponseModelFromJson(json);

  @override
  List<Object?> get props => [success, message, vaccineDetails];
}

@JsonSerializable()
class VaccineUserEntryDetailsModel extends Equatable {
  final String? id;
  final String? userId;
  final String? date;
  final String? targetAge;
  final String? vaccineName;
  final String? generation;
  final String? vaccineCategory;
  final String? perfectAge;
  final String? abbreviationCode;
  final String? vaccineActionDescription;
  final String? priorityTake;
  final String? targetDisease;
  final String? dose;
  final String? wayToTakeVaccine;
  final String? vaccinationProvider;
  final String? country;
  final String? additionalInfo;

  const VaccineUserEntryDetailsModel({
    this.id,
    this.userId,
    this.date,
    this.targetAge,
    this.vaccineName,
    this.generation,
    this.vaccineCategory,
    this.perfectAge,
    this.abbreviationCode,
    this.vaccineActionDescription,
    this.priorityTake,
    this.targetDisease,
    this.dose,
    this.wayToTakeVaccine,
    this.vaccinationProvider,
    this.country,
    this.additionalInfo,
  });

  factory VaccineUserEntryDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VaccineUserEntryDetailsModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        targetAge,
        vaccineName,
        generation,
        vaccineCategory,
        perfectAge,
        abbreviationCode,
        vaccineActionDescription,
        priorityTake,
        targetDisease,
        dose,
        wayToTakeVaccine,
        vaccinationProvider,
        country,
        additionalInfo,
      ];
}
