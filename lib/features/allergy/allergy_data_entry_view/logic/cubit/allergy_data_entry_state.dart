part of 'allergy_data_entry_cubit.dart';

@immutable
class AllergyDataEntryState extends Equatable {
  final RequestStatus surgeriesDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? allergyDateSelection;
  final String? alleryTypeSelection;
  final String? expectedSideEffectSelection;
  final String? selectedSyptomSeverity;
  final bool? isDoctorConsulted;
  final bool? isAllergyTestDn;
  final bool? isTreatmentsEffective;
  final bool? isEpinephrineInjectorCarried;
  final String? isAtRiskOfAnaphylaxis;
  final String? isThereMedicalWarningOnExposure;

  final String message; // error or success message
  final String? reportImageUploadedUrl;
  final UploadReportRequestStatus uploadReportStatus;
  final List<String> countriesNames;
  final String? selectedCountryName;
  final List<String> bodyParts;
  final List<String> subSurgeryRegions; // منطقة العمليية الفرعية
  final List<String> surgeryNames;
  // final String? selectedAllergyCauses;
  final List<String> selectedAllergyCauses; // Changed type

  final List<String> allTechUsed;
  final List<String> allSurgeryStatuses;
  final String? symptomOnsetAfterExposure; //زمن بدء الأعراض بعد التعرض للمسبب
  final String? surgeryPurpose;
  final String? selectedSurgeryStatus;
  final bool isEditMode;
  final String updatedSurgeryId;
  final String? surgeonName;
  final String? selectedHospitalCenter;
  final String? internistName; // طبيب باطنه

  const AllergyDataEntryState({
    this.surgeriesDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.allergyDateSelection,
    this.alleryTypeSelection,
    this.expectedSideEffectSelection,
    this.selectedSyptomSeverity,
    this.isDoctorConsulted,
    this.isAllergyTestDn,
    this.isTreatmentsEffective,
    this.isEpinephrineInjectorCarried,
    this.isAtRiskOfAnaphylaxis,
    this.isThereMedicalWarningOnExposure,
    this.message = '',
    this.reportImageUploadedUrl,
    this.uploadReportStatus = UploadReportRequestStatus.initial,
    this.countriesNames = const [],
    this.selectedCountryName,
    this.bodyParts = const [],
    this.subSurgeryRegions = const [],
    this.surgeryNames = const [],
    this.selectedAllergyCauses = const [],
    this.allTechUsed = const [],
    this.allSurgeryStatuses = const [],
    this.symptomOnsetAfterExposure,
    this.surgeryPurpose,
    this.selectedSurgeryStatus,
    this.isEditMode = false,
    this.updatedSurgeryId = '',
    this.surgeonName,
    this.selectedHospitalCenter,
    this.internistName,
  }) : super();

  const AllergyDataEntryState.initialState()
      : this(
          surgeriesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          allergyDateSelection: null,
          alleryTypeSelection: null,
          expectedSideEffectSelection: null,
          selectedSyptomSeverity: null,
          isDoctorConsulted: null,
          isAllergyTestDn: null,
          isTreatmentsEffective: null,
          isEpinephrineInjectorCarried: null,
          isThereMedicalWarningOnExposure: null,
          message: '',
          isAtRiskOfAnaphylaxis: null,
          reportImageUploadedUrl: null,
          uploadReportStatus: UploadReportRequestStatus.initial,
          countriesNames: const [],
          selectedCountryName: null,
          bodyParts: const [],
          subSurgeryRegions: const [],
          surgeryNames: const [],
          selectedAllergyCauses: const [],
          allTechUsed: const [],
          allSurgeryStatuses: const [],
          symptomOnsetAfterExposure: null,
          surgeryPurpose: null,
          selectedSurgeryStatus: null,
          isEditMode: false,
          updatedSurgeryId: '',
          surgeonName: null,
          selectedHospitalCenter: null,
          internistName: null,
        );

  AllergyDataEntryState copyWith({
    RequestStatus? surgeriesDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? allergyDateSelection,
    String? alleryTypeSelection,
    String? expectedSideEffectSelection,
    String? selectedSyptomSeverity,
    bool? isDoctorConsulted,
    bool? isAllergyTestDn,
    bool? isTreatmentsEffective,
    bool? isEpinephrineInjectorCarried,
    String? isAtRiskOfAnaphylaxis,
    String? isThereMedicalWarningOnExposure,
    String? message,
    String? reportImageUploadedUrl,
    UploadReportRequestStatus? uploadReportStatus,
    List<String>? countriesNames,
    String? selectedCountryName,
    List<String>? bodyParts,
    List<String>? subSurgeryRegions,
    List<String>? surgeryNames,
    List<String>? selectedAllergyCauses,
    List<String>? allTechUsed,
    List<String>? allSurgeryStatuses,
    String? symptomOnsetAfterExposure,
    String? surgeryPurpose,
    String? selectedSurgeryStatus,
    bool? isEditMode,
    String? updatedSurgeryId,
    String? surgeonName,
    String? selectedHospitalCenter,
    String? internistName,
  }) {
    return AllergyDataEntryState(
      surgeriesDataEntryStatus:
          surgeriesDataEntryStatus ?? this.surgeriesDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      allergyDateSelection: allergyDateSelection ?? this.allergyDateSelection,
      alleryTypeSelection: alleryTypeSelection ?? this.alleryTypeSelection,
      expectedSideEffectSelection:
          expectedSideEffectSelection ?? this.expectedSideEffectSelection,
      selectedSyptomSeverity:
          selectedSyptomSeverity ?? this.selectedSyptomSeverity,
      isDoctorConsulted: isDoctorConsulted ?? this.isDoctorConsulted,
      isAllergyTestDn: isAllergyTestDn ?? isAllergyTestDn,
      isThereMedicalWarningOnExposure:
          isThereMedicalWarningOnExposure ?? isThereMedicalWarningOnExposure,
      isEpinephrineInjectorCarried:
          isEpinephrineInjectorCarried ?? isEpinephrineInjectorCarried,
      isTreatmentsEffective: isTreatmentsEffective ?? isTreatmentsEffective,
      isAtRiskOfAnaphylaxis: isAtRiskOfAnaphylaxis ?? isAtRiskOfAnaphylaxis,
      message: message ?? this.message,
      reportImageUploadedUrl:
          reportImageUploadedUrl ?? this.reportImageUploadedUrl,
      uploadReportStatus: uploadReportStatus ?? this.uploadReportStatus,
      countriesNames: countriesNames ?? this.countriesNames,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      bodyParts: bodyParts ?? this.bodyParts,
      subSurgeryRegions: subSurgeryRegions ?? this.subSurgeryRegions,
      surgeryNames: surgeryNames ?? this.surgeryNames,
      selectedAllergyCauses:
          selectedAllergyCauses ?? this.selectedAllergyCauses,
      allTechUsed: allTechUsed ?? this.allTechUsed,
      allSurgeryStatuses: allSurgeryStatuses ?? this.allSurgeryStatuses,
      symptomOnsetAfterExposure:
          symptomOnsetAfterExposure ?? this.symptomOnsetAfterExposure,
      surgeryPurpose: surgeryPurpose ?? this.surgeryPurpose,
      selectedSurgeryStatus:
          selectedSurgeryStatus ?? this.selectedSurgeryStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedSurgeryId: updatedSurgeryId ?? this.updatedSurgeryId,
      surgeonName: surgeonName ?? this.surgeonName,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      internistName: internistName ?? this.internistName,
    );
  }

  @override
  List<Object?> get props => [
        surgeriesDataEntryStatus,
        errorMessage,
        isFormValidated,
        allergyDateSelection,
        alleryTypeSelection,
        isAllergyTestDn,
        isTreatmentsEffective,
        expectedSideEffectSelection,
        selectedSyptomSeverity,
        isDoctorConsulted,
        isEpinephrineInjectorCarried,
        isAtRiskOfAnaphylaxis,
        isThereMedicalWarningOnExposure,
        message,
        reportImageUploadedUrl,
        uploadReportStatus,
        countriesNames,
        selectedCountryName,
        bodyParts,
        subSurgeryRegions,
        surgeryNames,
        selectedAllergyCauses,
        allTechUsed,
        allSurgeryStatuses,
        symptomOnsetAfterExposure,
        surgeryPurpose,
        selectedSurgeryStatus,
        isEditMode,
        updatedSurgeryId,
        surgeonName,
        selectedHospitalCenter,
        internistName,
      ];
}
