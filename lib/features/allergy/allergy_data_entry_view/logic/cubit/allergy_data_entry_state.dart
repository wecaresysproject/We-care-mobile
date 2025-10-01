part of 'allergy_data_entry_cubit.dart';

@immutable
class AllergyDataEntryState extends Equatable {
  final RequestStatus allergyDataEntryStatus;
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
  final List<String> allergyTypes;
  final List<String> selectedAllergyCauses; // Changed type

  final List<String> allergyTriggers;
  final String? symptomOnsetAfterExposure; //زمن بدء الأعراض بعد التعرض للمسبب
  final String? selectedMedicineName;
  final bool isEditMode;
  final String updatedDocId;

  const AllergyDataEntryState({
    this.allergyDataEntryStatus = RequestStatus.initial,
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
    this.allergyTypes = const [],
    this.selectedAllergyCauses = const [],
    this.allergyTriggers = const [],
    this.symptomOnsetAfterExposure,
    this.selectedMedicineName,
    this.isEditMode = false,
    this.updatedDocId = '',
  }) : super();

  const AllergyDataEntryState.initialState()
      : this(
          allergyDataEntryStatus: RequestStatus.initial,
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
          allergyTypes: const [],
          selectedAllergyCauses: const [],
          allergyTriggers: const [],
          symptomOnsetAfterExposure: null,
          selectedMedicineName: null,
          isEditMode: false,
          updatedDocId: '',
        );

  AllergyDataEntryState copyWith({
    RequestStatus? allergyDataEntryStatus,
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
    List<String>? bodyParts,
    List<String>? allergyTypes,
    List<String>? selectedAllergyCauses,
    List<String>? allergyTriggers,
    String? symptomOnsetAfterExposure,
    String? selectedMedicineName,
    bool? isEditMode,
    String? updatedDocId,
  }) {
    return AllergyDataEntryState(
      allergyDataEntryStatus:
          allergyDataEntryStatus ?? this.allergyDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      allergyDateSelection: allergyDateSelection ?? this.allergyDateSelection,
      alleryTypeSelection: alleryTypeSelection ?? this.alleryTypeSelection,
      expectedSideEffectSelection:
          expectedSideEffectSelection ?? this.expectedSideEffectSelection,
      selectedSyptomSeverity:
          selectedSyptomSeverity ?? this.selectedSyptomSeverity,
      isDoctorConsulted: isDoctorConsulted ?? this.isDoctorConsulted,
      isAllergyTestDn: isAllergyTestDn ?? this.isAllergyTestDn,
      isThereMedicalWarningOnExposure: isThereMedicalWarningOnExposure ??
          this.isThereMedicalWarningOnExposure,
      isEpinephrineInjectorCarried:
          isEpinephrineInjectorCarried ?? this.isEpinephrineInjectorCarried,
      isTreatmentsEffective:
          isTreatmentsEffective ?? this.isTreatmentsEffective,
      isAtRiskOfAnaphylaxis:
          isAtRiskOfAnaphylaxis ?? this.isAtRiskOfAnaphylaxis,
      message: message ?? this.message,
      reportImageUploadedUrl:
          reportImageUploadedUrl ?? this.reportImageUploadedUrl,
      uploadReportStatus: uploadReportStatus ?? this.uploadReportStatus,
      allergyTypes: allergyTypes ?? this.allergyTypes,
      selectedAllergyCauses:
          selectedAllergyCauses ?? this.selectedAllergyCauses,
      allergyTriggers: allergyTriggers ?? this.allergyTriggers,
      symptomOnsetAfterExposure:
          symptomOnsetAfterExposure ?? this.symptomOnsetAfterExposure,
      selectedMedicineName: selectedMedicineName ?? this.selectedMedicineName,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedDocId: updatedDocId ?? this.updatedDocId,
    );
  }

  @override
  List<Object?> get props => [
        allergyDataEntryStatus,
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
        allergyTypes,
        selectedAllergyCauses,
        allergyTriggers,
        symptomOnsetAfterExposure,
        selectedMedicineName,
        isEditMode,
        updatedDocId,
      ];
}
