part of 'eyes_data_entry_cubit.dart';

@immutable
class EyesDataEntryState extends Equatable {
  final RequestStatus eyeDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? syptomStartDate;
  final String? symptomDuration;
  final String? procedureDateSelection;
  final String? surgeryBodyPartSelection;
  final String? surgeryNameSelection;
  final String message; // error or success message
  final String? reportImageUploadedUrl;
  final UploadReportRequestStatus uploadReportStatus;
  final String? medicalExaminationImageUploadedUrl;
  final UploadImageRequestStatus uploadMedicalExaminationStatus;
  final EyePartSyptomsAndProceduresResponseModel? eyePartSyptomsAndProcedures;

  final List<String> countriesNames;
  final String? selectedCountryName;
  final List<String> bodyParts;
  final List<String> subSurgeryRegions; // منطقة العمليية الفرعية
  final List<String> surgeryNames;
  final String? selectedSubSurgery; //المنطقة المختاره للعمليات الفرعية
  final List<String> allTechUsed;
  final List<String> allSurgeryStatuses;
  final String? selectedTechUsed; //المنطقة المختاره للعمليات الفرعية
  final String? surgeryPurpose;
  final String? selectedSurgeryStatus;
  final bool isEditMode;
  final String editDecumentId;
  final String? surgeonName;
  final String? selectedHospitalCenter;
  final String? doctorName;
  final String? affectedEyePart;

  const EyesDataEntryState({
    this.eyeDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.syptomStartDate,
    this.symptomDuration,
    this.procedureDateSelection,
    this.surgeryBodyPartSelection,
    this.surgeryNameSelection,
    this.message = '',
    this.reportImageUploadedUrl,
    this.uploadReportStatus = UploadReportRequestStatus.initial,
    this.medicalExaminationImageUploadedUrl,
    this.uploadMedicalExaminationStatus = UploadImageRequestStatus.initial,
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
    this.editDecumentId = '',
    this.surgeonName,
    this.selectedHospitalCenter,
    this.doctorName,
    this.eyePartSyptomsAndProcedures,
    this.affectedEyePart = '',
  }) : super();

  const EyesDataEntryState.initialState()
      : this(
          eyeDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          syptomStartDate: null,
          symptomDuration: null,
          procedureDateSelection: null,
          surgeryBodyPartSelection: null,
          surgeryNameSelection: null,
          message: '',
          reportImageUploadedUrl: null,
          uploadReportStatus: UploadReportRequestStatus.initial,
          medicalExaminationImageUploadedUrl: null,
          uploadMedicalExaminationStatus: UploadImageRequestStatus.initial,
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
          editDecumentId: '',
          surgeonName: null,
          selectedHospitalCenter: null,
          doctorName: null,
          eyePartSyptomsAndProcedures: null,
          affectedEyePart: null,
        );

  EyesDataEntryState copyWith({
    RequestStatus? eyeDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? syptomStartDate,
    String? symptomDuration,
    String? procedureDateSelection,
    String? surgeryBodyPartSelection,
    String? surgeryNameSelection,
    String? message,
    String? reportImageUploadedUrl,
    UploadReportRequestStatus? uploadReportStatus,
    String? medicalExaminationImageUploadedUrl,
    UploadImageRequestStatus? uploadMedicalExaminationStatus,
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
    String? editDecumentId,
    String? surgeonName,
    String? selectedHospitalCenter,
    String? doctorName,
    EyePartSyptomsAndProceduresResponseModel? eyePartSyptomsAndProcedures,
    String? affectedEyePart,
  }) {
    return EyesDataEntryState(
      eyeDataEntryStatus: eyeDataEntryStatus ?? this.eyeDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      syptomStartDate: syptomStartDate ?? this.syptomStartDate,
      procedureDateSelection:
          procedureDateSelection ?? this.procedureDateSelection,
      surgeryBodyPartSelection:
          surgeryBodyPartSelection ?? this.surgeryBodyPartSelection,
      surgeryNameSelection: surgeryNameSelection ?? this.surgeryNameSelection,
      message: message ?? this.message,
      reportImageUploadedUrl:
          reportImageUploadedUrl ?? this.reportImageUploadedUrl,
      medicalExaminationImageUploadedUrl: medicalExaminationImageUploadedUrl ??
          this.medicalExaminationImageUploadedUrl,
      uploadMedicalExaminationStatus:
          uploadMedicalExaminationStatus ?? this.uploadMedicalExaminationStatus,
      uploadReportStatus: uploadReportStatus ?? this.uploadReportStatus,
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
      editDecumentId: editDecumentId ?? this.editDecumentId,
      surgeonName: surgeonName ?? this.surgeonName,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      doctorName: doctorName ?? this.doctorName,
      symptomDuration: symptomDuration ?? this.symptomDuration,
      eyePartSyptomsAndProcedures:
          eyePartSyptomsAndProcedures ?? this.eyePartSyptomsAndProcedures,
      affectedEyePart: affectedEyePart ?? this.affectedEyePart,
    );
  }

  @override
  List<Object?> get props => [
        eyeDataEntryStatus,
        errorMessage,
        isFormValidated,
        syptomStartDate,
        surgeryBodyPartSelection,
        surgeryNameSelection,
        message,
        reportImageUploadedUrl,
        medicalExaminationImageUploadedUrl,
        uploadMedicalExaminationStatus,
        symptomDuration,
        procedureDateSelection,
        uploadReportStatus,
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
        editDecumentId,
        surgeonName,
        selectedHospitalCenter,
        doctorName,
        eyePartSyptomsAndProcedures,
        affectedEyePart,
      ];
}
