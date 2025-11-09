import 'package:json_annotation/json_annotation.dart';

part 'get_user_essential_info_response_model.g.dart';

@JsonSerializable()
class GetUserEssentialInfoResponseModel {
  final bool success;
  final String message;
  final UserEssentialInfoData? data;

  GetUserEssentialInfoResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory GetUserEssentialInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetUserEssentialInfoResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetUserEssentialInfoResponseModelToJson(this);
}

@JsonSerializable()
class UserEssentialInfoData {
  final String? docId;

  // --- Personal & Identification Data ---
  final String? fullName;
  final String? dateOfBirth;
  final String? nationalID;
  final String? email;
  final String? personalPhotoUrl;
  final String? country;
  final String? city;

  // --- Location & Work Data ---
  final String? areaOrDistrict;
  final String? bloodType;
  final String? workHours;
  final String? insuranceCompany;
  final String? insuranceCoverageExpiryDate;
  final String? insuranceCardPhotoUrl;
  final String? additionalTerms;

  // --- Health & Family Data ---
  final String? disabilityType;
  final String? disabilityDetails;
  final String? socialStatus;
  final int? numberOfChildren;
  final String? familyDoctorName;
  final String? emergencyContact1;
  final String? emergencyContact2;

  UserEssentialInfoData({
    this.docId,
    this.fullName,
    this.dateOfBirth,
    this.nationalID,
    this.email,
    this.personalPhotoUrl,
    this.country,
    this.city,
    this.areaOrDistrict,
    this.bloodType,
    this.workHours,
    this.insuranceCompany,
    this.insuranceCoverageExpiryDate,
    this.insuranceCardPhotoUrl,
    this.additionalTerms,
    this.disabilityType,
    this.disabilityDetails,
    this.socialStatus,
    this.numberOfChildren,
    this.familyDoctorName,
    this.emergencyContact1,
    this.emergencyContact2,
  });

  factory UserEssentialInfoData.fromJson(Map<String, dynamic> json) =>
      _$UserEssentialInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserEssentialInfoDataToJson(this);
}
