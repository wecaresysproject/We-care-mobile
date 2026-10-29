part of 'professional_licenses_cubit.dart';

class ProfessionalLicensesState extends Equatable {
  const ProfessionalLicensesState({
    required this.countriesNames,
    required this.entries,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory ProfessionalLicensesState.initial() => ProfessionalLicensesState(
        countriesNames: const [],
        entries: [LicenseFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<String> countriesNames;
  final List<LicenseFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved licenses. The form shows only on success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved licenses before, so the form opened
  /// pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  ProfessionalLicensesState copyWith({
    List<String>? countriesNames,
    List<LicenseFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return ProfessionalLicensesState(
      countriesNames: countriesNames ?? this.countriesNames,
      entries: entries ?? this.entries,
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
        entries,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
