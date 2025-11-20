part of 'eyes_data_entry_cubit.dart';

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
  final List<String> uploadedReportImages;
  final UploadReportRequestStatus uploadReportStatus;
  final List<String> medicalExaminationImages;
  final UploadImageRequestStatus uploadMedicalExaminationStatus;
  final EyePartSyptomsAndProceduresResponseModel? eyePartSyptomsAndProcedures;

  final List<String> countriesNames;
  final List<String> hospitalNames;
  final List<String> eyeMedicalCenters;
  final String? selectedCountryName;
  final List<String> bodyParts;
  final List<String> subSurgeryRegions; // منطقة العمليية الفرعية
  final List<String> surgeryNames;
  final List<String> doctorNames;
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
  final String? selectedEyeMedicalCenter;
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
    this.uploadedReportImages = const [],
    this.uploadReportStatus = UploadReportRequestStatus.initial,
    this.medicalExaminationImages = const [],
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
    this.selectedEyeMedicalCenter,
    this.doctorName,
    this.eyePartSyptomsAndProcedures,
    this.affectedEyePart = '',
    this.hospitalNames = const [],
    this.eyeMedicalCenters = const [],
    this.doctorNames = const [],
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
          uploadedReportImages: const [],
          uploadReportStatus: UploadReportRequestStatus.initial,
          medicalExaminationImages: const [],
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
          selectedEyeMedicalCenter: null,
          doctorName: null,
          eyePartSyptomsAndProcedures: null,
          affectedEyePart: null,
          hospitalNames: const [],
          eyeMedicalCenters: const [],
          doctorNames: const [],
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
    List<String>? uploadedReportImages,
    UploadReportRequestStatus? uploadReportStatus,
    List<String>? medicalExaminationImages,
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
    String? selectedEyeMedicalCenter,
    String? doctorName,
    EyePartSyptomsAndProceduresResponseModel? eyePartSyptomsAndProcedures,
    String? affectedEyePart,
    List<String>? hospitalNames,
    List<String>? eyeMedicalCenters,
    List<String>? doctorNames,
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
      uploadedReportImages: uploadedReportImages ?? this.uploadedReportImages,
      medicalExaminationImages:
          medicalExaminationImages ?? this.medicalExaminationImages,
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
      selectedEyeMedicalCenter:
          selectedEyeMedicalCenter ?? this.selectedEyeMedicalCenter,
      doctorName: doctorName ?? this.doctorName,
      symptomDuration: symptomDuration ?? this.symptomDuration,
      eyePartSyptomsAndProcedures:
          eyePartSyptomsAndProcedures ?? this.eyePartSyptomsAndProcedures,
      affectedEyePart: affectedEyePart ?? this.affectedEyePart,
      hospitalNames: hospitalNames ?? this.hospitalNames,
      eyeMedicalCenters: eyeMedicalCenters ?? this.eyeMedicalCenters,
      doctorNames: doctorNames ?? this.doctorNames,
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
        uploadedReportImages,
        medicalExaminationImages,
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
        selectedEyeMedicalCenter,
        doctorName,
        eyePartSyptomsAndProcedures,
        affectedEyePart,
        hospitalNames,
        eyeMedicalCenters,
        doctorNames,
      ];
}
