part of 'dental_data_entry_cubit.dart';

@immutable
class DentalDataEntryState extends Equatable {
  final RequestStatus dentalDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? startIssueDateSelection;
  final String? syptomTypeSelection;
  final String? natureOfComplaintSelection; //طبيعة الشكوى
  final String message; // error or success message
  final String? complaintDegree; //حدة الشكوى
  final String? medicalProcedureDateSelection; //تاريخ اجراء العملية
  final String? primaryMedicalProcedureSelection; //"الاجراء الطبى الرئيسى"
  final String? secondaryMedicalProcedureSelection; //"الاجراء الطبى الفرعي"
  final String? selectedSurroundingGumStatus; //حالة اللثة المحيطة
  final String? reportImageUploadedUrl;
  final String? xrayImageUploadedUrl;

  final UploadReportRequestStatus uploadReportStatus;
  final UploadImageRequestStatus xRayImageRequestStatus;
  final UploadImageRequestStatus
      oralPathologyReportStatus; // التحاليل الطبية الفموية
  final String? oralPathologySelection; //التحاليل الطبية الفموية
  final List<String> countriesNames;
  final String? selectedCountryName;
  final List<String> bodyParts;
  final List<String> subSurgeryRegions; // منطقة العمليية الفرعية
  final List<String> surgeryNames;
  final String? selectedSyptomsPeriod; //مدة الاعراض
  final List<String> allTechUsed;
  final List<String> allSurgeryStatuses;
  final String? selectedTechUsed; //المنطقة المختاره للعمليات الفرعية
  final String? surgeryPurpose;
  final bool isEditMode;
  final String updatedSurgeryId;
  final String? selectedHospitalCenter;
  final String? treatingDoctor; // طبيب باطنه

  const DentalDataEntryState({
    this.dentalDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.startIssueDateSelection,
    this.syptomTypeSelection,
    this.natureOfComplaintSelection,
    this.message = '',
    this.complaintDegree,
    this.medicalProcedureDateSelection,
    this.primaryMedicalProcedureSelection,
    this.secondaryMedicalProcedureSelection,
    this.selectedSurroundingGumStatus,
    this.reportImageUploadedUrl,
    this.xrayImageUploadedUrl,
    this.uploadReportStatus = UploadReportRequestStatus.initial,
    this.xRayImageRequestStatus = UploadImageRequestStatus.initial,
    this.oralPathologyReportStatus = UploadImageRequestStatus.initial,
    this.oralPathologySelection,
    this.countriesNames = const [],
    this.selectedCountryName,
    this.bodyParts = const [],
    this.subSurgeryRegions = const [],
    this.surgeryNames = const [],
    this.selectedSyptomsPeriod,
    this.allTechUsed = const [],
    this.allSurgeryStatuses = const [],
    this.selectedTechUsed,
    this.surgeryPurpose,
    this.isEditMode = false,
    this.updatedSurgeryId = '',
    this.selectedHospitalCenter,
    this.treatingDoctor,
  }) : super();

  const DentalDataEntryState.initialState()
      : this(
          dentalDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          startIssueDateSelection: null,
          syptomTypeSelection: null,
          natureOfComplaintSelection: null,
          complaintDegree: null,
          medicalProcedureDateSelection: null,
          primaryMedicalProcedureSelection: null,
          secondaryMedicalProcedureSelection: null,
          selectedSurroundingGumStatus: null,
          message: '',
          reportImageUploadedUrl: null,
          xrayImageUploadedUrl: null,
          uploadReportStatus: UploadReportRequestStatus.initial,
          xRayImageRequestStatus: UploadImageRequestStatus.initial,
          oralPathologyReportStatus: UploadImageRequestStatus.initial,
          oralPathologySelection: null,
          countriesNames: const [],
          selectedCountryName: null,
          bodyParts: const [],
          subSurgeryRegions: const [],
          surgeryNames: const [],
          selectedSyptomsPeriod: null,
          allTechUsed: const [],
          allSurgeryStatuses: const [],
          selectedTechUsed: null,
          surgeryPurpose: null,
          isEditMode: false,
          updatedSurgeryId: '',
          selectedHospitalCenter: null,
          treatingDoctor: null,
        );

  DentalDataEntryState copyWith({
    RequestStatus? dentalDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? startIssueDateSelection,
    String? medicalProcedureDateSelection,
    String? primaryMedicalProcedureSelection,
    String? secondaryMedicalProcedureSelection,
    String? syptomTypeSelection,
    String? natureOfComplaintSelection,
    String? complaintDegree,
    String? selectedSurroundingGumStatus,
    String? message,
    String? reportImageUploadedUrl,
    String? xrayImageUploadedUrl,
    UploadReportRequestStatus? uploadReportStatus,
    UploadImageRequestStatus? xRayImageRequestStatus,
    UploadImageRequestStatus? oralPathologyReportStatus,
    String? oralPathologySelection,
    List<String>? countriesNames,
    String? selectedCountryName,
    List<String>? bodyParts,
    List<String>? subSurgeryRegions,
    List<String>? surgeryNames,
    String? selectedSyptomsPeriod,
    List<String>? allTechUsed,
    List<String>? allSurgeryStatuses,
    String? selectedTechUsed,
    String? surgeryPurpose,
    bool? isEditMode,
    String? updatedSurgeryId,
    String? selectedHospitalCenter,
    String? treatingDoctor,
  }) {
    return DentalDataEntryState(
      dentalDataEntryStatus:
          dentalDataEntryStatus ?? this.dentalDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      startIssueDateSelection:
          startIssueDateSelection ?? this.startIssueDateSelection,
      medicalProcedureDateSelection:
          medicalProcedureDateSelection ?? this.medicalProcedureDateSelection,
      primaryMedicalProcedureSelection: primaryMedicalProcedureSelection ??
          this.primaryMedicalProcedureSelection,
      secondaryMedicalProcedureSelection: secondaryMedicalProcedureSelection ??
          this.secondaryMedicalProcedureSelection,
      syptomTypeSelection: syptomTypeSelection ?? this.syptomTypeSelection,
      natureOfComplaintSelection:
          natureOfComplaintSelection ?? this.natureOfComplaintSelection,
      complaintDegree: complaintDegree ?? this.complaintDegree,
      selectedSurroundingGumStatus:
          selectedSurroundingGumStatus ?? this.selectedSurroundingGumStatus,
      message: message ?? this.message,
      reportImageUploadedUrl:
          reportImageUploadedUrl ?? this.reportImageUploadedUrl,
      xrayImageUploadedUrl: xrayImageUploadedUrl ?? this.xrayImageUploadedUrl,
      uploadReportStatus: uploadReportStatus ?? this.uploadReportStatus,
      xRayImageRequestStatus:
          xRayImageRequestStatus ?? this.xRayImageRequestStatus,
      oralPathologyReportStatus:
          oralPathologyReportStatus ?? this.oralPathologyReportStatus,
      oralPathologySelection:
          oralPathologySelection ?? this.oralPathologySelection,
      countriesNames: countriesNames ?? this.countriesNames,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      bodyParts: bodyParts ?? this.bodyParts,
      subSurgeryRegions: subSurgeryRegions ?? this.subSurgeryRegions,
      surgeryNames: surgeryNames ?? this.surgeryNames,
      selectedSyptomsPeriod:
          selectedSyptomsPeriod ?? this.selectedSyptomsPeriod,
      allTechUsed: allTechUsed ?? this.allTechUsed,
      allSurgeryStatuses: allSurgeryStatuses ?? this.allSurgeryStatuses,
      selectedTechUsed: selectedTechUsed ?? this.selectedTechUsed,
      surgeryPurpose: surgeryPurpose ?? this.surgeryPurpose,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedSurgeryId: updatedSurgeryId ?? this.updatedSurgeryId,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      treatingDoctor: treatingDoctor ?? this.treatingDoctor,
    );
  }

  @override
  List<Object?> get props => [
        dentalDataEntryStatus,
        errorMessage,
        isFormValidated,
        startIssueDateSelection,
        syptomTypeSelection,
        natureOfComplaintSelection,
        complaintDegree,
        medicalProcedureDateSelection,
        primaryMedicalProcedureSelection,
        secondaryMedicalProcedureSelection,
        selectedSurroundingGumStatus,
        message,
        reportImageUploadedUrl,
        xrayImageUploadedUrl,
        uploadReportStatus,
        xRayImageRequestStatus,
        oralPathologyReportStatus,
        oralPathologySelection,
        countriesNames,
        selectedCountryName,
        bodyParts,
        subSurgeryRegions,
        surgeryNames,
        selectedSyptomsPeriod,
        allTechUsed,
        allSurgeryStatuses,
        selectedTechUsed,
        surgeryPurpose,
        isEditMode,
        updatedSurgeryId,
        selectedHospitalCenter,
        treatingDoctor,
      ];
}
