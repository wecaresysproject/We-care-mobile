import 'package:we_care/features/doctor/bank_info/data/models/bank_account_model.dart';

class BankInfoRequestBodyModel {
  final List<BankAccountModel> bankAccounts;

  BankInfoRequestBodyModel({required this.bankAccounts});

  factory BankInfoRequestBodyModel.fromJson(Map<String, dynamic> json) =>
      BankInfoRequestBodyModel(
        bankAccounts: (json['bankAccounts'] as List? ?? const [])
            .map((e) => BankAccountModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'bankAccounts':
            bankAccounts.map((account) => account.toJson()).toList(),
      };
}
