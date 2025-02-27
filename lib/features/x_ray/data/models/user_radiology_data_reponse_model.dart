import 'package:json_annotation/json_annotation.dart';

part 'user_radiology_data_reponse_model.g.dart';

@JsonSerializable()
class UserRadiologyDataResponse {
  bool success;
  String message;
  @JsonKey(name: 'data')
  List<RadiologyData> radiologyData;

  UserRadiologyDataResponse(
      {required this.success,
      required this.message,
      required this.radiologyData});

  factory UserRadiologyDataResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRadiologyDataResponseFromJson(json);
}

@JsonSerializable()
class RadiologyData {
  String? id;
  String radiologyDate;
  String bodyPart;
  String radioType;
  String? periodicUsage;
  @JsonKey(name: 'photo')
  String radiologyPhoto;
  String? report;
  @JsonKey(name: 'cause')
  String? symptoms;
  String? hospital;
  String? radiologyDoctor;
  @JsonKey(name: 'curedDoctor')
  String? doctor;
  String? country;
  String userId;
  String? radiologyNote;
  String? userType;
  String? language;

  RadiologyData({
    required this.id,
    required this.radiologyDate,
    required this.bodyPart,
    required this.radioType,
    this.periodicUsage,
    required this.radiologyPhoto,
    this.report,
    this.symptoms,
    this.hospital,
    this.radiologyDoctor,
    this.doctor,
    this.country,
    required this.userId,
    this.radiologyNote,
    this.userType,
    this.language,
  });

  factory RadiologyData.fromJson(Map<String, dynamic> json) =>
      _$RadiologyDataFromJson(json);
}
