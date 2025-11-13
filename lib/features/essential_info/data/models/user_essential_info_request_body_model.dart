import 'package:json_annotation/json_annotation.dart';

part 'user_essential_info_request_body_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserEssentialInfoRequestBodyModel {
  final String fullName;
  final String dateOfBirth;
  final String nationalID;
  final String email;
  final String personalPhotoUrl;
  final String country;
  final String city;
  final String areaOrDistrict;
  final String bloodType;
  final InsuranceDetails insuranceDetails;
  final String disabilityLevel;
  final String disabilityType;
  final String? socialStatus;
  final int numberOfChildren;
  final String familyDoctorName;
  final String workHours;
  final String emergencyContact1;
  final String emergencyContact2;
  final String familyDoctorPhoneNumber;

  UserEssentialInfoRequestBodyModel({
    required this.fullName,
    required this.dateOfBirth,
    required this.nationalID,
    required this.email,
    required this.personalPhotoUrl,
    required this.country,
    required this.city,
    required this.areaOrDistrict,
    required this.bloodType,
    required this.insuranceDetails,
    required this.disabilityLevel,
    required this.disabilityType,
    required this.socialStatus,
    required this.numberOfChildren,
    required this.familyDoctorName,
    required this.workHours,
    required this.emergencyContact1,
    required this.emergencyContact2,
    required this.familyDoctorPhoneNumber,
  });

  factory UserEssentialInfoRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$UserEssentialInfoRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UserEssentialInfoRequestBodyModelToJson(this);
}

@JsonSerializable()
class InsuranceDetails {
  final bool? insuranceStatus;
  final String? insuranceCompany;
  final String? insuranceCoverageExpiryDate;
  final String? insuranceCardPhotoUrl;
  final String? additionalInsuranceTerms;

  InsuranceDetails({
    required this.insuranceStatus,
    required this.insuranceCompany,
    required this.insuranceCoverageExpiryDate,
    required this.insuranceCardPhotoUrl,
    required this.additionalInsuranceTerms,
  });

  factory InsuranceDetails.fromJson(Map<String, dynamic> json) =>
      _$InsuranceDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$InsuranceDetailsToJson(this);
}
