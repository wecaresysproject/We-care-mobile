part of 'surgery_data_entry_cubit.dart';

@immutable
class SurgeryDataEntryState extends Equatable {
  final RequestStatus surgeriesDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? surgeryDateSelection;
  final String? surgeryBodyPartSelection;
  final String? surgeryNameSelection;
  final String message; // error or success message
  final String? reportImageUploadedUrl;
  final UploadReportRequestStatus surgeryUploadReportStatus;
  final List<String> countriesNames;
  final String? selectedCountryName;

  const SurgeryDataEntryState({
    this.surgeriesDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.surgeryDateSelection,
    this.surgeryBodyPartSelection,
    this.surgeryNameSelection,
    this.message = '',
    this.reportImageUploadedUrl,
    this.surgeryUploadReportStatus = UploadReportRequestStatus.initial,
    this.countriesNames = const [],
    this.selectedCountryName,
  }) : super();

  const SurgeryDataEntryState.initialState()
      : this(
          surgeriesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          surgeryDateSelection: null,
          surgeryBodyPartSelection: null,
          surgeryNameSelection: null,
          message: '',
          reportImageUploadedUrl: null,
          surgeryUploadReportStatus: UploadReportRequestStatus.initial,
          countriesNames: const [],
          selectedCountryName: null,
        );

  SurgeryDataEntryState copyWith({
    RequestStatus? surgeriesDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? surgeryDateSelection,
    String? surgeryBodyPartSelection,
    String? surgeryNameSelection,
    String? message,
    String? reportImageUploadedUrl,
    UploadReportRequestStatus? surgeryUploadReportStatus,
    List<String>? countriesNames,
    String? selectedCountryName,
  }) {
    return SurgeryDataEntryState(
      surgeriesDataEntryStatus:
          surgeriesDataEntryStatus ?? this.surgeriesDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      surgeryDateSelection: surgeryDateSelection ?? this.surgeryDateSelection,
      surgeryBodyPartSelection:
          surgeryBodyPartSelection ?? this.surgeryBodyPartSelection,
      surgeryNameSelection: surgeryNameSelection ?? this.surgeryNameSelection,
      message: message ?? this.message,
      reportImageUploadedUrl:
          reportImageUploadedUrl ?? this.reportImageUploadedUrl,
      surgeryUploadReportStatus:
          surgeryUploadReportStatus ?? this.surgeryUploadReportStatus,
      countriesNames: countriesNames ?? this.countriesNames,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
    );
  }

  @override
  List<Object?> get props => [
        surgeriesDataEntryStatus,
        errorMessage,
        isFormValidated,
        surgeryDateSelection,
        surgeryBodyPartSelection,
        surgeryNameSelection,
        message,
        reportImageUploadedUrl,
        surgeryUploadReportStatus,
        countriesNames,
        selectedCountryName,
      ];
}
