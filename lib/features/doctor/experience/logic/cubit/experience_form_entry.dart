import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/experience/data/models/experience_model.dart';

/// One experience card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [ExperienceCubit], not by the state class, mirroring
/// `CertificateFormEntry`.
class ExperienceFormEntry {
  ExperienceFormEntry() : key = UniqueKey();

  final Key key;
  String? selectedCountry;
  String? fromDate;
  String? toDate;

  final positionController = TextEditingController();
  final workPlaceController = TextEditingController();

  ExperienceModel toModel() => ExperienceModel(
        position: positionController.text.trim(),
        workPlace: workPlaceController.text.trim(),
        fromDate: fromDate ?? '',
        toDate: toDate ?? '',
        countryName: selectedCountry ?? '',
      );

  void dispose() {
    positionController.dispose();
    workPlaceController.dispose();
  }
}
