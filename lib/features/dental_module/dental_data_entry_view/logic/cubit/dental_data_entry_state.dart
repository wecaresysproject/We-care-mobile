part of 'dental_data_entry_cubit.dart';

@immutable
class DentalDataEntryState extends Equatable {
  final RequestStatus dentalDataEntryStatus;
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
  final String? selectedSyptomsPeriod; //مدة الاعراض
  final bool isEditMode;
  final String? selectedHospitalCenter;
  final String? treatingDoctor; // طبيب باطنه
  final String updatedTeethId;

  const DentalDataEntryState({
    this.dentalDataEntryStatus = RequestStatus.initial,
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
    this.selectedSyptomsPeriod,
    this.isEditMode = false,
    this.updatedTeethId = '',
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
          selectedSyptomsPeriod: null,
          isEditMode: false,
          updatedTeethId: '',
          selectedHospitalCenter: null,
          treatingDoctor: null,
        );

  DentalDataEntryState copyWith({
    RequestStatus? dentalDataEntryStatus,
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
    String? selectedSyptomsPeriod,
    bool? isEditMode,
    String? updatedTeethId,
    String? selectedHospitalCenter,
    String? treatingDoctor,
  }) {
    return DentalDataEntryState(
      dentalDataEntryStatus:
          dentalDataEntryStatus ?? this.dentalDataEntryStatus,
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
      selectedSyptomsPeriod:
          selectedSyptomsPeriod ?? this.selectedSyptomsPeriod,
      isEditMode: isEditMode ?? this.isEditMode,
      updatedTeethId: updatedTeethId ?? this.updatedTeethId,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      treatingDoctor: treatingDoctor ?? this.treatingDoctor,
    );
  }

  @override
  List<Object?> get props => [
        dentalDataEntryStatus,
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
        selectedSyptomsPeriod,
        isEditMode,
        updatedTeethId,
        selectedHospitalCenter,
        treatingDoctor,
      ];
}
