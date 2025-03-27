import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_surgeries_response_model.g.dart';

@JsonSerializable()
class GetUserSurgeriesResponseModal {
  bool success;
  String message;
  @JsonKey(name: 'data')
  List<SurgeryModel> surgeries;

  GetUserSurgeriesResponseModal({
    required this.success,
    required this.message,
    required this.surgeries,
  });

  factory GetUserSurgeriesResponseModal.fromJson(Map<String, dynamic> json) =>
      _$GetUserSurgeriesResponseModalFromJson(json);
}

@JsonSerializable()
class SurgeryModel {
  String id;
  String userId;
  String surgeryDate;
  String surgeryRegion;
  String subSurgeryRegion;
  String? purpose;
  String? ichiCode;
  String? description;
  String surgeryName;
  String usedTechnique;
  String surgeryDescription;
  String medicalReportImage;
  String surgeryStatus;
  String hospitalCenter;
  String surgeonName;
  String anesthesiologistName;
  String postSurgeryInstructions;
  String country;
  String additionalNotes;

  SurgeryModel({
    required this.id,
    required this.userId,
    required this.surgeryDate,
    required this.surgeryRegion,
    required this.subSurgeryRegion,
    this.purpose,
    this.ichiCode,
    this.description,
    required this.surgeryName,
    required this.usedTechnique,
    required this.surgeryDescription,
    required this.medicalReportImage,
    required this.surgeryStatus,
    required this.hospitalCenter,
    required this.surgeonName,
    required this.anesthesiologistName,
    required this.postSurgeryInstructions,
    required this.country,
    required this.additionalNotes,
  });

  factory SurgeryModel.fromJson(Map<String, dynamic> json) =>
      _$SurgeryModelFromJson(json);
}
