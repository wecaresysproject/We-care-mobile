import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/membership/data/models/membership_model.dart';

/// One membership card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [MembershipCubit], not by the state class, mirroring
/// `ExperienceFormEntry`.
class MembershipFormEntry {
  MembershipFormEntry() : key = UniqueKey();

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

  void dispose() {
    associationNameController.dispose();
    membershipNumberController.dispose();
  }
}
