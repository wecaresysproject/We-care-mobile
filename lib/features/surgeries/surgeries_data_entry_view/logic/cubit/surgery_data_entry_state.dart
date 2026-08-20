part of 'surgery_data_entry_cubit.dart';

/// How the "التقنية المستخدمة" field should behave for the currently selected
/// surgery. The cubit owns this decision so the UI never has to infer it from
/// [SurgeryDataEntryState.allTechUsed] being empty — an empty list on its own
/// cannot tell "still loading" from "custom surgery" from "lookup failed".
enum TechniqueResolutionState {
  /// No surgery name picked yet — we genuinely don't know what the field is.
  initial,

  /// Resolving the technique catalogue for the chosen surgery.
  loading,

  /// A curated catalogue exists — required dropdown.
  hasPredefinedOptions,

  /// No catalogue to choose from (custom surgery, empty catalogue, or a failed
  /// lookup) — optional free text.
  noPredefinedOptions,
}

@immutable
class SurgeryDataEntryState extends Equatable {
  final RequestStatus surgeriesDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? surgeryDateSelection;
  final String? surgeryBodyPartSelection;
  final String? surgeryNameSelection;
  final String message; // error or success message
  final List<String> reportsImageUploadedUrls;
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
  final TechniqueResolutionState techniqueResolution;

  /// True when the last technique lookup failed. Purely an affordance for
  /// offering a retry — it never changes which control renders, so a failed
  /// lookup can't block the user.
  final bool techniqueOptionsLoadFailed;
  final String? surgeryPurpose;
  final String? selectedSurgeryStatus;
  final bool isEditMode;
  final String updatedSurgeryId;
  final String? surgeonName;
  final String? selectedHospitalCenter;
  final String? internistName; // طبيب باطنه
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const SurgeryDataEntryState({
    this.surgeriesDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.surgeryDateSelection,
    this.surgeryBodyPartSelection,
    this.surgeryNameSelection,
    this.message = '',
    this.reportsImageUploadedUrls = const [],
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
    this.techniqueResolution = TechniqueResolutionState.initial,
    this.techniqueOptionsLoadFailed = false,
    this.surgeryPurpose,
    this.selectedSurgeryStatus,
    this.isEditMode = false,
    this.updatedSurgeryId = '',
    this.surgeonName,
    this.selectedHospitalCenter,
    this.internistName,
    this.doctorNames = const [],
    this.hospitals = const [],
    this.moduleGuidanceData,
  }) : super();

  const SurgeryDataEntryState.initialState()
      : this(
          surgeriesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          surgeryDateSelection: null,
          surgeryBodyPartSelection: null,
          surgeryNameSelection: null,
          message: '',
          reportsImageUploadedUrls: const [],
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
          techniqueResolution: TechniqueResolutionState.initial,
          techniqueOptionsLoadFailed: false,
          surgeryPurpose: null,
          selectedSurgeryStatus: null,
          isEditMode: false,
          updatedSurgeryId: '',
          surgeonName: null,
          selectedHospitalCenter: null,
          internistName: null,
          doctorNames: const [],
          hospitals: const [],
          moduleGuidanceData: null,
        );

  /// The field is absent only before a surgery has ever been picked; from then
  /// on it is always on screen in some form, so a value the user already has
  /// can never become unreachable.
  bool get isTechniqueFieldVisible =>
      techniqueResolution != TechniqueResolutionState.initial;

  bool get isTechniqueRequired =>
      techniqueResolution == TechniqueResolutionState.hasPredefinedOptions;

  bool get isTechniqueResolved =>
      techniqueResolution == TechniqueResolutionState.hasPredefinedOptions ||
      techniqueResolution == TechniqueResolutionState.noPredefinedOptions;

  /// The purpose is derived server-side from the full surgery + technique
  /// tuple, so there is nothing to show for a custom surgery.
  bool get isSurgeryPurposeVisible => surgeryPurpose?.isNotEmpty ?? false;

  SurgeryDataEntryState copyWith({
    RequestStatus? surgeriesDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? surgeryDateSelection,
    String? surgeryBodyPartSelection,
    String? surgeryNameSelection,
    String? message,
    List<String>? reportsImageUploadedUrls,
    UploadReportRequestStatus? surgeryUploadReportStatus,
    List<String>? countriesNames,
    String? selectedCountryName,
    List<String>? bodyParts,
    List<String>? subSurgeryRegions,
    List<String>? surgeryNames,
    String? selectedSubSurgery,
    List<String>? allTechUsed,
    List<String>? allSurgeryStatuses,

    /// Passed as a getter rather than a bare value so these can actually be
    /// reset to null. With the plain `value ?? this.value` form used by every
    /// other field here, `null` means "leave unchanged" and clearing is a
    /// silent no-op — which is how a technique from a previously selected
    /// surgery used to survive onto the next one.
    ValueGetter<String?>? selectedTechUsed,
    ValueGetter<String?>? surgeryPurpose,
    TechniqueResolutionState? techniqueResolution,
    bool? techniqueOptionsLoadFailed,
    String? selectedSurgeryStatus,
    bool? isEditMode,
    String? updatedSurgeryId,
    String? surgeonName,
    String? selectedHospitalCenter,
    String? internistName,
    List<String>? doctorNames,
    List<String>? hospitals,
    ModuleGuidanceDataModel? moduleGuidanceData,
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
      reportsImageUploadedUrls:
          reportsImageUploadedUrls ?? this.reportsImageUploadedUrls,
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
      selectedTechUsed:
          selectedTechUsed != null ? selectedTechUsed() : this.selectedTechUsed,
      techniqueResolution: techniqueResolution ?? this.techniqueResolution,
      techniqueOptionsLoadFailed:
          techniqueOptionsLoadFailed ?? this.techniqueOptionsLoadFailed,
      surgeryPurpose:
          surgeryPurpose != null ? surgeryPurpose() : this.surgeryPurpose,
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
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
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
        reportsImageUploadedUrls,
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
        techniqueResolution,
        techniqueOptionsLoadFailed,
        surgeryPurpose,
        selectedSurgeryStatus,
        isEditMode,
        updatedSurgeryId,
        surgeonName,
        selectedHospitalCenter,
        internistName,
        doctorNames,
        hospitals,
        moduleGuidanceData,
      ];
}
