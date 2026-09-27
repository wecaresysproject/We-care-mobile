import 'package:json_annotation/json_annotation.dart';

part 'doctor_basic_data_request_body_model.g.dart';

@JsonSerializable()
class DoctorBasicDataRequestBodyModel {
  final String personalPhotoUrl;
  final String firstName;
  final String fatherName;
  final String familyName;
  final String jobGrade;
  final String academicDegree;
  final String gender;
  final String birthDate;
  final String country;
  final String governorate;
  final String city;
  final String professionalMobileCountryCode;
  final String professionalMobileNumber;
  final String contactMobileCountryCode;
  final String contactMobileNumber;
  final String nationalIdOrPassportNumber;
  final String nationalIdOrPassportPhotoUrl;
  final List<String> spokenLanguages;
  final String shortBio;

  DoctorBasicDataRequestBodyModel({
    required this.personalPhotoUrl,
    required this.firstName,
    required this.fatherName,
    required this.familyName,
    required this.jobGrade,
    required this.academicDegree,
    required this.gender,
    required this.birthDate,
    required this.country,
    required this.governorate,
    required this.city,
    required this.professionalMobileCountryCode,
    required this.professionalMobileNumber,
    required this.contactMobileCountryCode,
    required this.contactMobileNumber,
    required this.nationalIdOrPassportNumber,
    required this.nationalIdOrPassportPhotoUrl,
    required this.spokenLanguages,
    required this.shortBio,
  });

  Map<String, dynamic> toJson() =>
      _$DoctorBasicDataRequestBodyModelToJson(this);
}
