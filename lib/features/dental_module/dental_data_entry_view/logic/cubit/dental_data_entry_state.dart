part of 'dental_data_entry_cubit.dart';

@immutable
class DentalDataEntryState extends Equatable {
  final RequestStatus dentalDataEntryStatus;
  final ToothOperationDetails? pastEditedToothData;
  final bool isFormValidated;
  final String? startIssueDateSelection;
  final String? syptomTypeSelection;
  final String? natureOfComplaintSelection; //طبيعة الشكوى
  final String message; // error or success message
  final String? complaintDegree; //حدة الشكوى
  final List<String> mainProcedures;
  final List<String> secondaryProcedures;
  final List<String> doctorNames; //اسماء الاطباء
  final List<String> complainDurations;
  final List<String> complainTypes;
  final List<String> complainNatures;
  final List<String> allGumsConditions; //حالة اللثة
  final List<String> allOralMedicalTests; //التحاليل الطبية الفموية

  final String? medicalProcedureDateSelection; //تاريخ اجراء العملية
  final String? primaryMedicalProcedureSelection; //"الاجراء الطبى الرئيسى"
  final String? secondaryMedicalProcedureSelection; //"الاجراء الطبى الفرعي"
  final String? selectedSurroundingGumStatus; //حالة اللثة المحيطة
  final String? reportImageUploadedUrl;
  final String? xrayImageUploadedUrl;
  final String? lymphAnalysisImageUploadedUrl;

  final UploadReportRequestStatus uploadReportStatus;
  final UploadImageRequestStatus xRayImageRequestStatus;
  final UploadImageRequestStatus lymphAnalysisImageStatus;
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
    this.pastEditedToothData,
    this.startIssueDateSelection,
    this.syptomTypeSelection,
    this.natureOfComplaintSelection,
    this.message = '',
    this.complaintDegree,
    this.medicalProcedureDateSelection,
    this.mainProcedures = const [],
    this.secondaryProcedures = const [],
    this.doctorNames = const [],
    this.complainDurations = const [],
    this.complainTypes = const [],
    this.complainNatures = const [],
    this.allGumsConditions = const [],
    this.allOralMedicalTests = const [],
    this.primaryMedicalProcedureSelection,
    this.secondaryMedicalProcedureSelection,
    this.selectedSurroundingGumStatus,
    this.reportImageUploadedUrl,
    this.xrayImageUploadedUrl,
    this.lymphAnalysisImageUploadedUrl,
    this.uploadReportStatus = UploadReportRequestStatus.initial,
    this.xRayImageRequestStatus = UploadImageRequestStatus.initial,
    this.oralPathologyReportStatus = UploadImageRequestStatus.initial,
    this.lymphAnalysisImageStatus = UploadImageRequestStatus.initial,
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
          pastEditedToothData: null,
          mainProcedures: const [],
          secondaryProcedures: const [],
          doctorNames: const [],
          complainDurations: const [],
          complainTypes: const [],
          complainNatures: const [],
          allGumsConditions: const [],
          allOralMedicalTests: const [],
          primaryMedicalProcedureSelection: null,
          secondaryMedicalProcedureSelection: null,
          selectedSurroundingGumStatus: null,
          message: '',
          reportImageUploadedUrl: null,
          xrayImageUploadedUrl: null,
          uploadReportStatus: UploadReportRequestStatus.initial,
          xRayImageRequestStatus: UploadImageRequestStatus.initial,
          oralPathologyReportStatus: UploadImageRequestStatus.initial,
          lymphAnalysisImageStatus: UploadImageRequestStatus.initial,
          lymphAnalysisImageUploadedUrl: null,
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
    ToothOperationDetails? pastEditedToothData,
    bool? isFormValidated,
    String? startIssueDateSelection,
    List<String>? mainProcedures,
    List<String>? secondaryProcedures,
    String? medicalProcedureDateSelection,
    String? primaryMedicalProcedureSelection,
    List<String>? doctorNames,
    List<String>? complainDurations,
    List<String>? complainTypes,
    List<String>? complainNatures,
    List<String>? allGumsConditions,
    List<String>? allOralMedicalTests,
    String? secondaryMedicalProcedureSelection,
    String? syptomTypeSelection,
    String? natureOfComplaintSelection,
    String? complaintDegree,
    String? selectedSurroundingGumStatus,
    String? message,
    String? reportImageUploadedUrl,
    String? xrayImageUploadedUrl,
    String? lymphAnalysisImageUploadedUrl,
    UploadReportRequestStatus? uploadReportStatus,
    UploadImageRequestStatus? xRayImageRequestStatus,
    UploadImageRequestStatus? oralPathologyReportStatus,
    UploadImageRequestStatus? lymphAnalysisImageStatus,
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
      pastEditedToothData: pastEditedToothData ?? this.pastEditedToothData,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      startIssueDateSelection:
          startIssueDateSelection ?? this.startIssueDateSelection,
      mainProcedures: mainProcedures ?? this.mainProcedures,
      secondaryProcedures: secondaryProcedures ?? this.secondaryProcedures,
      doctorNames: doctorNames ?? this.doctorNames,
      complainDurations: complainDurations ?? this.complainDurations,
      complainTypes: complainTypes ?? this.complainTypes,
      complainNatures: complainNatures ?? this.complainNatures,
      allGumsConditions: allGumsConditions ?? this.allGumsConditions,
      allOralMedicalTests: allOralMedicalTests ?? this.allOralMedicalTests,
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
      lymphAnalysisImageStatus:
          lymphAnalysisImageStatus ?? this.lymphAnalysisImageStatus,
      lymphAnalysisImageUploadedUrl:
          lymphAnalysisImageUploadedUrl ?? this.lymphAnalysisImageUploadedUrl,
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
        pastEditedToothData,
        isFormValidated,
        startIssueDateSelection,
        syptomTypeSelection,
        natureOfComplaintSelection,
        complaintDegree,
        medicalProcedureDateSelection,
        mainProcedures,
        secondaryProcedures,
        doctorNames,
        complainDurations,
        complainTypes,
        complainNatures,
        allGumsConditions,
        allOralMedicalTests,
        primaryMedicalProcedureSelection,
        secondaryMedicalProcedureSelection,
        selectedSurroundingGumStatus,
        message,
        reportImageUploadedUrl,
        xrayImageUploadedUrl,
        uploadReportStatus,
        xRayImageRequestStatus,
        oralPathologyReportStatus,
        lymphAnalysisImageStatus,
        lymphAnalysisImageUploadedUrl,
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
