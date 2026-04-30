import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_vaccines_response_model.g.dart';

@JsonSerializable()
class GetUserVaccinesResponseModel extends Equatable {
  final bool success;
  final String message;
  @JsonKey(name: 'data')
  final List<UserVaccineModel> userVaccines;

  const GetUserVaccinesResponseModel({
    required this.success,
    required this.message,
    required this.userVaccines,
  });

  factory GetUserVaccinesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetUserVaccinesResponseModelFromJson(json);

  @override
  List<Object?> get props => [success, message, userVaccines];
}

@JsonSerializable()
class UserVaccineModel extends Equatable {
  final String? date;
  final String? vaccineName;
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

  const UserVaccineModel({
    this.date,
    this.vaccineName,
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

  factory UserVaccineModel.fromJson(Map<String, dynamic> json) =>
      _$UserVaccineModelFromJson(json);

  @override
  List<Object?> get props => [
        date,
        vaccineName,
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
