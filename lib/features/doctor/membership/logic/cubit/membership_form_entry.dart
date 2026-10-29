import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/membership/data/models/membership_model.dart';

/// One membership card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [MembershipCubit], not by the state class, mirroring
/// `ExperienceFormEntry`.
class MembershipFormEntry {
  MembershipFormEntry() : key = UniqueKey();

  /// An entry filled with a membership loaded from the server.
  factory MembershipFormEntry.fromModel(MembershipModel model) {
    final entry = MembershipFormEntry()
      ..selectedCountry = model.countryName.isEmpty ? null : model.countryName
      ..selectedMembershipLevel =
          model.membershipLevel.isEmpty ? null : model.membershipLevel
      ..selectedYear = model.year.isEmpty ? null : model.year;
    entry.associationNameController.text = model.associationName;
    entry.membershipNumberController.text = model.membershipNumber;
    return entry;
  }

  final Key key;
  String? selectedCountry;
  String? selectedMembershipLevel;
  String? selectedYear;

  final associationNameController = TextEditingController();
  final membershipNumberController = TextEditingController();

  MembershipModel toModel() => MembershipModel(
        countryName: selectedCountry ?? '',
        associationName: associationNameController.text.trim(),
        membershipNumber: membershipNumberController.text.trim(),
        membershipLevel: selectedMembershipLevel ?? '',
        year: selectedYear ?? '',
      );

  /// Calls [listener] whenever one of this entry's text fields changes.
  void addTextListener(VoidCallback listener) {
    associationNameController.addListener(listener);
    membershipNumberController.addListener(listener);
  }

  void dispose() {
    associationNameController.dispose();
    membershipNumberController.dispose();
  }
}
