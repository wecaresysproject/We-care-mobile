part of 'glasses_data_entry_cubit.dart';

@immutable
class GlassesDataEntryState extends Equatable {
  final RequestStatus glassesEssentialDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? examinationDateSelection;
  final String? surgeryBodyPartSelection;
  final String? surgeryNameSelection;
  final String message; // error or success message
  final String? reportImageUploadedUrl;
  final UploadReportRequestStatus surgeryUploadReportStatus;
  final List<String> countriesNames;
  final String? selectedCountryName;
  final List<String> bodyParts;
  final List<String> subSurgeryRegions; // منطقة العمليية الفرعية
  final List<String> doctorNames;
  final String? selectedSubSurgery; //المنطقة المختاره للعمليات الفرعية
  final List<String> allTechUsed;
  final List<String> allSurgeryStatuses;
  final String? selectedTechUsed; //المنطقة المختاره للعمليات الفرعية
  final String? surgeryPurpose;
  final String? selectedSurgeryStatus;
  final bool isEditMode;
  final String updatedSurgeryId;
  final String? selectedHospitalCenter;
  final String? doctorName;

  const GlassesDataEntryState({
    this.glassesEssentialDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.examinationDateSelection,
    this.surgeryBodyPartSelection,
    this.surgeryNameSelection,
    this.message = '',
    this.reportImageUploadedUrl,
    this.surgeryUploadReportStatus = UploadReportRequestStatus.initial,
    this.countriesNames = const [],
    this.selectedCountryName,
    this.bodyParts = const [],
    this.subSurgeryRegions = const [],
    this.doctorNames = const [],
    this.selectedSubSurgery,
    this.allTechUsed = const [],
    this.allSurgeryStatuses = const [],
    this.selectedTechUsed,
    this.surgeryPurpose,
    this.selectedSurgeryStatus,
    this.isEditMode = false,
    this.updatedSurgeryId = '',
    this.selectedHospitalCenter,
    this.doctorName,
  }) : super();

  const GlassesDataEntryState.initialState()
      : this(
          glassesEssentialDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          examinationDateSelection: null,
          surgeryBodyPartSelection: null,
          surgeryNameSelection: null,
          message: '',
          reportImageUploadedUrl: null,
          surgeryUploadReportStatus: UploadReportRequestStatus.initial,
          countriesNames: const [],
          selectedCountryName: null,
          bodyParts: const [],
          subSurgeryRegions: const [],
          doctorNames: const [],
          selectedSubSurgery: null,
          allTechUsed: const [],
          allSurgeryStatuses: const [],
          selectedTechUsed: null,
          surgeryPurpose: null,
          selectedSurgeryStatus: null,
          isEditMode: false,
          updatedSurgeryId: '',
          selectedHospitalCenter: null,
          doctorName: null,
        );

  GlassesDataEntryState copyWith({
    RequestStatus? glassesEssentialDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? examinationDateSelection,
    String? surgeryBodyPartSelection,
    String? surgeryNameSelection,
    String? message,
    String? reportImageUploadedUrl,
    UploadReportRequestStatus? surgeryUploadReportStatus,
    List<String>? countriesNames,
    String? selectedCountryName,
    List<String>? bodyParts,
    List<String>? subSurgeryRegions,
    List<String>? doctorNames,
    String? selectedSubSurgery,
    List<String>? allTechUsed,
    List<String>? allSurgeryStatuses,
    String? selectedTechUsed,
    String? surgeryPurpose,
    String? selectedSurgeryStatus,
    bool? isEditMode,
    String? updatedSurgeryId,
    String? selectedHospitalCenter,
    String? doctorName,
  }) {
    return GlassesDataEntryState(
      glassesEssentialDataEntryStatus: glassesEssentialDataEntryStatus ??
          this.glassesEssentialDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      examinationDateSelection:
          examinationDateSelection ?? this.examinationDateSelection,
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
      doctorNames: doctorNames ?? this.doctorNames,
      selectedSubSurgery: selectedSubSurgery ?? this.selectedSubSurgery,
      allTechUsed: allTechUsed ?? this.allTechUsed,
      allSurgeryStatuses: allSurgeryStatuses ?? this.allSurgeryStatuses,
      selectedTechUsed: selectedTechUsed ?? this.selectedTechUsed,
      surgeryPurpose: surgeryPurpose ?? this.surgeryPurpose,
      selectedSurgeryStatus:
          selectedSurgeryStatus ?? this.selectedSurgeryStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedSurgeryId: updatedSurgeryId ?? this.updatedSurgeryId,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      doctorName: doctorName ?? this.doctorName,
    );
  }

  @override
  List<Object?> get props => [
        glassesEssentialDataEntryStatus,
        errorMessage,
        isFormValidated,
        examinationDateSelection,
        surgeryBodyPartSelection,
        surgeryNameSelection,
        message,
        reportImageUploadedUrl,
        surgeryUploadReportStatus,
        countriesNames,
        selectedCountryName,
        bodyParts,
        subSurgeryRegions,
        doctorNames,
        selectedSubSurgery,
        allTechUsed,
        allSurgeryStatuses,
        selectedTechUsed,
        surgeryPurpose,
        selectedSurgeryStatus,
        isEditMode,
        updatedSurgeryId,
        selectedHospitalCenter,
        doctorName,
      ];
}
