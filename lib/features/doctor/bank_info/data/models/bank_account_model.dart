import 'package:json_annotation/json_annotation.dart';

part 'bank_account_model.g.dart';

@JsonSerializable()
class BankAccountModel {
  final String countryName;
  final String userName;
  final String bankName;
  final String branchName;
  final String accountNumber;
  final String iban;

  BankAccountModel({
    required this.countryName,
    required this.userName,
    required this.bankName,
    required this.branchName,
    required this.accountNumber,
    required this.iban,
  });

  Map<String, dynamic> toJson() => _$BankAccountModelToJson(this);
}
