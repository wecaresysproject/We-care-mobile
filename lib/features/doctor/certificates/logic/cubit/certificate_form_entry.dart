import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_model.dart';

/// One certificate card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [CertificatesCubit], not by the state class, mirroring
/// how [BankInfoCubit] keeps its `TextEditingController`s on the cubit rather
/// than in the (Equatable) state.
class CertificateFormEntry {
  CertificateFormEntry() : key = UniqueKey();

  final Key key;
  String? selectedCountry;
  String? obtainedDate;

  final degreeTitleController = TextEditingController();
  final grantingBodyController = TextEditingController();

  CertificateModel toModel() => CertificateModel(
        degreeTitle: degreeTitleController.text.trim(),
        grantingBody: grantingBodyController.text.trim(),
        countryName: selectedCountry ?? '',
        obtainedDate: obtainedDate ?? '',
      );

  void dispose() {
    degreeTitleController.dispose();
    grantingBodyController.dispose();
  }
}
