import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/license_model.dart';

/// One license card's editable state — a stable [key] so Flutter can track
/// each card across list rebuilds, plus the controllers/selection for its
/// fields. Held by [ProfessionalLicensesCubit], not by the state class,
/// mirroring `ExperienceFormEntry`.
class LicenseFormEntry {
  LicenseFormEntry() : key = UniqueKey();

  final Key key;
  String? selectedCountry;
  String? licenseDate;
  String? expiryDate;
  String? licenseImageUrl;
  UploadImageRequestStatus? licenseImageUploadStatus;

  final licenseNumberController = TextEditingController();
  final licensingAuthorityController = TextEditingController();
  final registrationNumberController = TextEditingController();

  LicenseModel toModel() => LicenseModel(
        licenseNumber: licenseNumberController.text.trim(),
        countryName: selectedCountry ?? '',
        licensingAuthority: licensingAuthorityController.text.trim(),
        registrationNumber: registrationNumberController.text.trim(),
        licenseDate: licenseDate ?? '',
        expiryDate: expiryDate ?? '',
        licenseImageUrl: licenseImageUrl ?? '',
      );

  void dispose() {
    licenseNumberController.dispose();
    licensingAuthorityController.dispose();
    registrationNumberController.dispose();
  }
}
