import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/awards/data/models/award_model.dart';

/// One award card's editable state — a stable [key] so Flutter can track
/// each card across list rebuilds, plus the controllers/selection for its
/// fields. Held by [AwardsCubit], not by the state class, mirroring
/// `MembershipFormEntry`.
class AwardFormEntry {
  AwardFormEntry() : key = UniqueKey();

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

  void dispose() {
    awardNameController.dispose();
    grantingBodyController.dispose();
  }
}
