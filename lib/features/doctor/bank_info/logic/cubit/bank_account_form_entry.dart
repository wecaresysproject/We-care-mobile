import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/bank_info/data/models/bank_account_model.dart';

/// One bank-account card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers/selection for
/// its fields. Held by [BankInfoCubit], not by the state class, mirroring
/// how [DoctorBasicDataCubit] keeps its `TextEditingController`s on the
/// cubit rather than in the (Equatable) state.
class BankAccountFormEntry {
  BankAccountFormEntry({this.selectedCountry}) : key = UniqueKey();

  final Key key;
  String? selectedCountry;

  final userNameController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ibanController = TextEditingController();

  BankAccountModel toModel() => BankAccountModel(
        countryName: selectedCountry ?? '',
        userName: userNameController.text.trim(),
        bankName: bankNameController.text.trim(),
        branchName: branchNameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        iban: ibanController.text.trim(),
      );

  void dispose() {
    userNameController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    accountNumberController.dispose();
    ibanController.dispose();
  }
}
