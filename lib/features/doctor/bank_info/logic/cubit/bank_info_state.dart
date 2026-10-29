part of 'bank_info_cubit.dart';

class BankInfoState extends Equatable {
  const BankInfoState({
    required this.countriesNames,
    required this.accounts,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory BankInfoState.initial() => BankInfoState(
        countriesNames: const [],
        accounts: [BankAccountFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<String> countriesNames;
  final List<BankAccountFormEntry> accounts;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved bank accounts. The form shows only on
  /// success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved bank accounts before, so the form
  /// opened pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  BankInfoState copyWith({
    List<String>? countriesNames,
    List<BankAccountFormEntry>? accounts,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return BankInfoState(
      countriesNames: countriesNames ?? this.countriesNames,
      accounts: accounts ?? this.accounts,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      loadStatus: loadStatus ?? this.loadStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        accounts,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
