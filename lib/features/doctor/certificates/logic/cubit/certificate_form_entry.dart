import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_model.dart';

/// One certificate card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [CertificatesCubit], not by the state class, mirroring
/// how [BankInfoCubit] keeps its `TextEditingController`s on the cubit rather
/// than in the (Equatable) state.
class CertificateFormEntry {
  CertificateFormEntry() : key = UniqueKey();

  /// An entry filled with a certificate loaded from the server.
  factory CertificateFormEntry.fromModel(CertificateModel model) {
    final entry = CertificateFormEntry()
      ..selectedCountry = model.countryName.isEmpty ? null : model.countryName
      ..obtainedDate = model.obtainedDate.isEmpty ? null : model.obtainedDate;
    entry.degreeTitleController.text = model.degreeTitle;
    entry.grantingBodyController.text = model.grantingBody;
    return entry;
  }

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

  /// Calls [listener] whenever one of this entry's text fields changes.
  void addTextListener(VoidCallback listener) {
    degreeTitleController.addListener(listener);
    grantingBodyController.addListener(listener);
  }

  void dispose() {
    degreeTitleController.dispose();
    grantingBodyController.dispose();
  }
}
