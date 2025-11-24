import 'package:json_annotation/json_annotation.dart';

part 'get_user_prescriptions_response_model.g.dart';

@JsonSerializable()
class GetUserPrescriptionsResponseModel {
  bool success;
  String message;
  @JsonKey(name: 'data')
  List<PrescriptionModel> prescriptionList;

  GetUserPrescriptionsResponseModel(
      {required this.success,
      required this.message,
      required this.prescriptionList});

  factory GetUserPrescriptionsResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$GetUserPrescriptionsResponseModelFromJson(json);
}

@JsonSerializable()
class PrescriptionModel {
  String id;
  String userId;
  String userType;
  String language;
  String preDescriptionDate;
  String doctorName;
  String doctorSpecialty;
  String cause;
  String disease;
  List<String> preDescriptionPhoto;
  String country;
  String governate;
  String preDescriptionNotes;
  String modifiedAt;

  PrescriptionModel(
      {required this.id,
      required this.userId,
      required this.userType,
      required this.language,
      required this.preDescriptionDate,
      required this.doctorName,
      required this.doctorSpecialty,
      required this.cause,
      required this.disease,
      required this.preDescriptionPhoto,
      required this.country,
      required this.governate,
      required this.preDescriptionNotes,
      required this.modifiedAt});

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionModelFromJson(json);
}
