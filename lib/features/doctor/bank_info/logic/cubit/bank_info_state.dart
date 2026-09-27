part of 'bank_info_cubit.dart';

class BankInfoState extends Equatable {
  const BankInfoState({
    required this.countriesNames,
    required this.accounts,
    required this.submissionStatus,
    required this.message,
  });

  factory BankInfoState.initial() => BankInfoState(
        countriesNames: const [],
        accounts: [BankAccountFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final List<BankAccountFormEntry> accounts;

  final RequestStatus submissionStatus;
  final String? message;

  BankInfoState copyWith({
    List<String>? countriesNames,
    List<BankAccountFormEntry>? accounts,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return BankInfoState(
      countriesNames: countriesNames ?? this.countriesNames,
      accounts: accounts ?? this.accounts,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        accounts,
        submissionStatus,
        message,
      ];
}
