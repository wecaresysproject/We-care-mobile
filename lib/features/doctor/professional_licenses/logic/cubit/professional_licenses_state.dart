part of 'professional_licenses_cubit.dart';

class ProfessionalLicensesState extends Equatable {
  const ProfessionalLicensesState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
  });

  factory ProfessionalLicensesState.initial() => ProfessionalLicensesState(
        countriesNames: const [],
        entries: [LicenseFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final List<LicenseFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  ProfessionalLicensesState copyWith({
    List<String>? countriesNames,
    List<LicenseFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return ProfessionalLicensesState(
      countriesNames: countriesNames ?? this.countriesNames,
      entries: entries ?? this.entries,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        entries,
        submissionStatus,
        message,
      ];
}
