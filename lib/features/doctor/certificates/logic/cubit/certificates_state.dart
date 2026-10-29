part of 'certificates_cubit.dart';

class CertificatesState extends Equatable {
  const CertificatesState({
    required this.countriesNames,
    required this.sections,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory CertificatesState.initial() => CertificatesState(
        countriesNames: const [],
        sections: {
          for (final section in CertificateSectionType.values)
            section: [CertificateFormEntry()],
        },
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<String> countriesNames;
  final Map<CertificateSectionType, List<CertificateFormEntry>> sections;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved certificates. The form shows only on
  /// success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved at least one certificate (in any
  /// section), so the form opened pre-filled and the button reads
  /// "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  CertificatesState copyWith({
    List<String>? countriesNames,
    Map<CertificateSectionType, List<CertificateFormEntry>>? sections,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return CertificatesState(
      countriesNames: countriesNames ?? this.countriesNames,
      sections: sections ?? this.sections,
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
        sections,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
