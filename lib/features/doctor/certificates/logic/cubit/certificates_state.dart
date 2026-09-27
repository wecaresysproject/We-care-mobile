part of 'certificates_cubit.dart';

class CertificatesState extends Equatable {
  const CertificatesState({
    required this.countriesNames,
    required this.sections,
    required this.submissionStatus,
    required this.message,
  });

  factory CertificatesState.initial() => CertificatesState(
        countriesNames: const [],
        sections: {
          for (final section in CertificateSectionType.values)
            section: [CertificateFormEntry()],
        },
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> countriesNames;
  final Map<CertificateSectionType, List<CertificateFormEntry>> sections;

  final RequestStatus submissionStatus;
  final String? message;

  CertificatesState copyWith({
    List<String>? countriesNames,
    Map<CertificateSectionType, List<CertificateFormEntry>>? sections,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return CertificatesState(
      countriesNames: countriesNames ?? this.countriesNames,
      sections: sections ?? this.sections,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        countriesNames,
        sections,
        submissionStatus,
        message,
      ];
}
