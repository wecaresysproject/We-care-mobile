import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/license_model.dart';

/// One license card's editable state — a stable [key] so Flutter can track
/// each card across list rebuilds, plus the controllers/selection for its
/// fields. Held by [ProfessionalLicensesCubit], not by the state class,
/// mirroring `ExperienceFormEntry`.
class LicenseFormEntry {
  LicenseFormEntry() : key = UniqueKey();

  /// An entry filled with a license loaded from the server. A saved image
  /// URL is marked as uploaded so the existing preview shows it.
  factory LicenseFormEntry.fromModel(LicenseModel model) {
    final hasImage = model.licenseImageUrl.isNotEmpty;
    final entry = LicenseFormEntry()
      ..selectedCountry = model.countryName.isEmpty ? null : model.countryName
      ..licenseDate = model.licenseDate.isEmpty ? null : model.licenseDate
      ..expiryDate = model.expiryDate.isEmpty ? null : model.expiryDate
      ..licenseImageUrl = hasImage ? model.licenseImageUrl : null
      ..licenseImageUploadStatus =
          hasImage ? UploadImageRequestStatus.success : null;
    entry.licenseNumberController.text = model.licenseNumber;
    entry.licensingAuthorityController.text = model.licensingAuthority;
    entry.registrationNumberController.text = model.registrationNumber;
    return entry;
  }

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

  /// Calls [listener] whenever one of this entry's text fields changes.
  void addTextListener(VoidCallback listener) {
    licenseNumberController.addListener(listener);
    licensingAuthorityController.addListener(listener);
    registrationNumberController.addListener(listener);
  }

  void dispose() {
    licenseNumberController.dispose();
    licensingAuthorityController.dispose();
    registrationNumberController.dispose();
  }
}
