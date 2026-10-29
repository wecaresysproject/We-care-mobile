import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/awards/data/models/award_model.dart';

/// One award card's editable state — a stable [key] so Flutter can track
/// each card across list rebuilds, plus the controllers/selection for its
/// fields. Held by [AwardsCubit], not by the state class, mirroring
/// `MembershipFormEntry`.
class AwardFormEntry {
  AwardFormEntry() : key = UniqueKey();

  /// An entry filled with an award loaded from the server.
  factory AwardFormEntry.fromModel(AwardModel model) {
    final entry = AwardFormEntry()
      ..selectedCountry = model.countryName.isEmpty ? null : model.countryName
      ..selectedYear = model.year.isEmpty ? null : model.year;
    entry.awardNameController.text = model.awardName;
    entry.grantingBodyController.text = model.grantingBody;
    return entry;
  }

  final Key key;
  String? selectedCountry;
  String? selectedYear;

  final awardNameController = TextEditingController();
  final grantingBodyController = TextEditingController();

  AwardModel toModel() => AwardModel(
        awardName: awardNameController.text.trim(),
        countryName: selectedCountry ?? '',
        grantingBody: grantingBodyController.text.trim(),
        year: selectedYear ?? '',
      );

  /// Calls [listener] whenever one of this entry's text fields changes.
  void addTextListener(VoidCallback listener) {
    awardNameController.addListener(listener);
    grantingBodyController.addListener(listener);
  }

  void dispose() {
    awardNameController.dispose();
    grantingBodyController.dispose();
  }
}
