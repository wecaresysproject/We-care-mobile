import 'package:json_annotation/json_annotation.dart';

part 'license_model.g.dart';

@JsonSerializable()
class LicenseModel {
  final String licenseNumber;
  final String countryName;
  final String licensingAuthority;
  final String registrationNumber;
  final String licenseDate;
  final String expiryDate;
  final String licenseImageUrl;

  LicenseModel({
    required this.licenseNumber,
    required this.countryName,
    required this.licensingAuthority,
    required this.registrationNumber,
    required this.licenseDate,
    required this.expiryDate,
    required this.licenseImageUrl,
  });

  Map<String, dynamic> toJson() => _$LicenseModelToJson(this);
}
