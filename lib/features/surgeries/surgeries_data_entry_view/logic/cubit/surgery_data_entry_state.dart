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
  final List<String> doctorNames;
  final String? selectedCountryName;
  final List<String> bodyParts;
  final List<String> subSurgeryRegions; // منطقة العمليية الفرعية
  final List<String> surgeryNames;
  final String? selectedSubSurgery; //المنطقة المختاره للعمليات الفرعية
  final List<String> allTechUsed;
  final List<String> hospitals;
  final List<String> allSurgeryStatuses;
  final String? selectedTechUsed; //المنطقة المختاره للعمليات الفرعية
  final String? surgeryPurpose;
  final String? selectedSurgeryStatus;
  final bool isEditMode;
  final String updatedSurgeryId;
  final String? surgeonName;
  final String? selectedHospitalCenter;
  final String? internistName; // طبيب باطنه

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
    this.bodyParts = const [],
    this.subSurgeryRegions = const [],
    this.surgeryNames = const [],
    this.selectedSubSurgery,
    this.allTechUsed = const [],
    this.allSurgeryStatuses = const [],
    this.selectedTechUsed,
    this.surgeryPurpose,
    this.selectedSurgeryStatus,
    this.isEditMode = false,
    this.updatedSurgeryId = '',
    this.surgeonName,
    this.selectedHospitalCenter,
    this.internistName,
    this.doctorNames = const [],
    this.hospitals = const [],
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
          bodyParts: const [],
          subSurgeryRegions: const [],
          surgeryNames: const [],
          selectedSubSurgery: null,
          allTechUsed: const [],
          allSurgeryStatuses: const [],
          selectedTechUsed: null,
          surgeryPurpose: null,
          selectedSurgeryStatus: null,
          isEditMode: false,
          updatedSurgeryId: '',
          surgeonName: null,
          selectedHospitalCenter: null,
          internistName: null,
          doctorNames: const [],
          hospitals: const [],
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
    List<String>? bodyParts,
    List<String>? subSurgeryRegions,
    List<String>? surgeryNames,
    String? selectedSubSurgery,
    List<String>? allTechUsed,
    List<String>? allSurgeryStatuses,
    String? selectedTechUsed,
    String? surgeryPurpose,
    String? selectedSurgeryStatus,
    bool? isEditMode,
    String? updatedSurgeryId,
    String? surgeonName,
    String? selectedHospitalCenter,
    String? internistName,
    List<String>? doctorNames,
    List<String>? hospitals,
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
      bodyParts: bodyParts ?? this.bodyParts,
      subSurgeryRegions: subSurgeryRegions ?? this.subSurgeryRegions,
      surgeryNames: surgeryNames ?? this.surgeryNames,
      selectedSubSurgery: selectedSubSurgery ?? this.selectedSubSurgery,
      allTechUsed: allTechUsed ?? this.allTechUsed,
      allSurgeryStatuses: allSurgeryStatuses ?? this.allSurgeryStatuses,
      selectedTechUsed: selectedTechUsed ?? this.selectedTechUsed,
      surgeryPurpose: surgeryPurpose ?? this.surgeryPurpose,
      selectedSurgeryStatus:
          selectedSurgeryStatus ?? this.selectedSurgeryStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedSurgeryId: updatedSurgeryId ?? this.updatedSurgeryId,
      surgeonName: surgeonName ?? this.surgeonName,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      internistName: internistName ?? this.internistName,
      doctorNames: doctorNames ?? this.doctorNames,
      hospitals: hospitals ?? this.hospitals,
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
        bodyParts,
        subSurgeryRegions,
        surgeryNames,
        selectedSubSurgery,
        allTechUsed,
        allSurgeryStatuses,
        selectedTechUsed,
        surgeryPurpose,
        selectedSurgeryStatus,
        isEditMode,
        updatedSurgeryId,
        surgeonName,
        selectedHospitalCenter,
        internistName,
        doctorNames,
        hospitals,
      ];
}
