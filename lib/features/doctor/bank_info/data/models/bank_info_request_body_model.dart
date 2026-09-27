import 'package:we_care/features/doctor/bank_info/data/models/bank_account_model.dart';

class BankInfoRequestBodyModel {
  final List<BankAccountModel> bankAccounts;

  BankInfoRequestBodyModel({required this.bankAccounts});

  Map<String, dynamic> toJson() => {
        'bankAccounts':
            bankAccounts.map((account) => account.toJson()).toList(),
      };
}
