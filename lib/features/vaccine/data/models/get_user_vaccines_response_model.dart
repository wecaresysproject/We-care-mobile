import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_vaccines_response_model.g.dart';

@JsonSerializable()
class GetUserVaccinesResponseModel {
  bool success;
  String message;
  @JsonKey(name: 'data')
  List<UserVaccineModel> userVaccines;

  GetUserVaccinesResponseModel(
      {required this.success,
      required this.message,
      required this.userVaccines});

  factory GetUserVaccinesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetUserVaccinesResponseModelFromJson(json);
}

@JsonSerializable()
class UserVaccineModel {
  String id;
  String userId;
  String vaccineName;
  @JsonKey(name: 'vaccinecategory')
  String vaccineCategory;
  @JsonKey(name: 'vaccineperfectage')
  String vaccinePerfectAge;
  @JsonKey(name: 'userage')
  String userAge;
  String vaccineDate;
  String dose;
  String diseases;
  String doseDaily;
  String wayToTakeVaccine;
  String priorityTake;
  String ageSection;
  String sideEffects;
  String regionForVaccine;
  String country;
  String notes;

  UserVaccineModel(
      {required this.id,
      required this.userId,
      required this.vaccineName,
      required this.vaccineCategory,
      required this.vaccinePerfectAge,
      required this.userAge,
      required this.vaccineDate,
      required this.dose,
      required this.diseases,
      required this.doseDaily,
      required this.wayToTakeVaccine,
      required this.priorityTake,
      required this.ageSection,
      required this.sideEffects,
      required this.regionForVaccine,
      required this.country,
      required this.notes});

  factory UserVaccineModel.fromJson(Map<String, dynamic> json) =>
      _$UserVaccineModelFromJson(json);
}
