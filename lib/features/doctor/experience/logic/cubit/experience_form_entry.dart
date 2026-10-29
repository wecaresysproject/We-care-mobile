import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/experience/data/models/experience_model.dart';

/// One experience card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [ExperienceCubit], not by the state class, mirroring
/// `CertificateFormEntry`.
class ExperienceFormEntry {
  ExperienceFormEntry() : key = UniqueKey();

  /// An entry filled with an experience loaded from the server.
  factory ExperienceFormEntry.fromModel(ExperienceModel model) {
    final entry = ExperienceFormEntry()
      ..selectedCountry = model.countryName.isEmpty ? null : model.countryName
      ..fromDate = model.fromDate.isEmpty ? null : model.fromDate
      ..toDate = model.toDate.isEmpty ? null : model.toDate;
    entry.positionController.text = model.position;
    entry.workPlaceController.text = model.workPlace;
    return entry;
  }

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

  /// Calls [listener] whenever one of this entry's text fields changes.
  void addTextListener(VoidCallback listener) {
    positionController.addListener(listener);
    workPlaceController.addListener(listener);
  }

  void dispose() {
    positionController.dispose();
    workPlaceController.dispose();
  }
}
