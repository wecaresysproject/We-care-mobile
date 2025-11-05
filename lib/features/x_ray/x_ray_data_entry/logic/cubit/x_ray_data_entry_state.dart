part of 'x_ray_data_entry_cubit.dart';

@immutable
class XRayDataEntryState extends Equatable {
  final RequestStatus xRayDataEntryStatus;
  final List<String> bodyPartNames; // اسماء منطقة الاشعه
  final List<String> radiologyTypesBasedOnBodyPartNameSelected; // نوعية الاشعه
  final List<BodyPartsResponseModel> bodyPartsDataModels;
  final List<String> puposesOfSelectedXRayType; // نوعية الاحتياج للاشعه
  final String? selectedPupose;
  final String? selectedHospitalName;
  final String? selectedLabCenter;
  final List<RadiologyTypeOfBodyPartModel>?
      selectedRadiologyTypesOfBodyPartModel;
  final List<String> countriesNames;
  final List<String> hospitalNames;
  final List<String> labCenters;
  final List<String> doctorNames;
  final String message; // error or success message
  final bool isFormValidated;
  final String? xRayDateSelection;
  final String? xRayBodyPartSelection;
  final String? xRayTypeSelection;
  final String? selectedCountryName;
  final String? selectedTreatedDoctor;
  final String? selectedRadiologistDoctorName;
  final bool? isXRayPictureSelected;
  final String xRayPictureUploadedUrl;

  final String xRayReportUploadedUrl;
  final UploadImageRequestStatus xRayImageRequestStatus;
  final UploadReportRequestStatus xRayReportRequestStatus;
  final RadiologyData? xRayEditedModel;
  final bool isEditMode;

  const XRayDataEntryState({
    this.selectedPupose,
    this.countriesNames = const [],
    this.xRayDataEntryStatus = RequestStatus.initial,
    this.bodyPartNames = const [],
    this.radiologyTypesBasedOnBodyPartNameSelected = const [],
    this.bodyPartsDataModels = const [],
    this.puposesOfSelectedXRayType = const [],
    this.message = '',
    this.isFormValidated = false,
    this.xRayDateSelection,
    this.xRayBodyPartSelection,
    this.selectedCountryName,
    this.xRayTypeSelection,
    this.isXRayPictureSelected,
    this.selectedRadiologyTypesOfBodyPartModel,
    this.xRayPictureUploadedUrl = '',
    this.xRayReportUploadedUrl = '',
    this.xRayImageRequestStatus = UploadImageRequestStatus.initial,
    this.xRayReportRequestStatus = UploadReportRequestStatus.initial,
    this.xRayEditedModel,
    this.isEditMode = false,
    this.doctorNames = const [],
    this.selectedTreatedDoctor,
    this.selectedRadiologistDoctorName,
    this.hospitalNames = const [],
    this.labCenters = const [],
    this.selectedLabCenter,
    this.selectedHospitalName,
  }) : super();

  const XRayDataEntryState.initialState()
      : this(
          xRayDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          xRayDateSelection: null,
          xRayBodyPartSelection: null,
          xRayTypeSelection: null,
          isXRayPictureSelected: null,
          selectedRadiologyTypesOfBodyPartModel: null,
          selectedPupose: null,
          message: '',
          selectedCountryName: null,
          xRayImageRequestStatus: UploadImageRequestStatus.initial,
          xRayReportRequestStatus: UploadReportRequestStatus.initial,
          isEditMode: false,
          doctorNames: const [],
          selectedTreatedDoctor: null,
          selectedRadiologistDoctorName: null,
          hospitalNames: const [],
          labCenters: const [],
          selectedLabCenter: null,
          selectedHospitalName: null,
        );

  XRayDataEntryState copyWith({
    RequestStatus? xRayDataEntryStatus,
    bool? isFormValidated,
    String? xRayDateSelection,
    String? xRayBodyPartSelection,
    String? xRayTypeSelection,
    bool? isXRayPictureSelected,
    List<String>? bodyPartNames,
    List<String>? radiologyTypesBasedOnBodyPartNameSelected,
    List<BodyPartsResponseModel>? bodyPartsDataModels,
    List<String>? puposesOfSelectedXRayType,
    List<RadiologyTypeOfBodyPartModel>? selectedRadiologyTypesOfBodyPartModel,
    List<String>? countriesNames,
    String? selectedCountryName,
    String? selectedPupose,
    String? message,
    String? xRayPictureUploadedUrl,
    String? xRayReportUploadedUrl,
    UploadImageRequestStatus? xRayImageRequestStatus,
    UploadReportRequestStatus? xRayReportRequestStatus,
    RadiologyData? xRayEditedModel,
    bool? isEditMode,
    List<String>? doctorNames,
    String? selectedTreatedDoctor,
    String? selectedRadiologistDoctorName,
    List<String>? hospitalNames,
    List<String>? labCenters,
    String? selectedLabCenter,
    String? selectedHospitalName,
  }) {
    return XRayDataEntryState(
      xRayDataEntryStatus: xRayDataEntryStatus ?? this.xRayDataEntryStatus,
      message: message ?? this.message,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      xRayDateSelection: xRayDateSelection ?? this.xRayDateSelection,
      xRayBodyPartSelection:
          xRayBodyPartSelection ?? this.xRayBodyPartSelection,
      xRayTypeSelection: xRayTypeSelection ?? this.xRayTypeSelection,
      isXRayPictureSelected:
          isXRayPictureSelected ?? this.isXRayPictureSelected,
      bodyPartNames: bodyPartNames ?? this.bodyPartNames,
      radiologyTypesBasedOnBodyPartNameSelected:
          radiologyTypesBasedOnBodyPartNameSelected ??
              this.radiologyTypesBasedOnBodyPartNameSelected,
      bodyPartsDataModels: bodyPartsDataModels ?? this.bodyPartsDataModels,
      puposesOfSelectedXRayType:
          puposesOfSelectedXRayType ?? this.puposesOfSelectedXRayType,
      selectedRadiologyTypesOfBodyPartModel:
          selectedRadiologyTypesOfBodyPartModel ??
              this.selectedRadiologyTypesOfBodyPartModel,
      countriesNames: countriesNames ?? this.countriesNames,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      selectedPupose: selectedPupose ?? this.selectedPupose,
      xRayPictureUploadedUrl:
          xRayPictureUploadedUrl ?? this.xRayPictureUploadedUrl,
      xRayReportUploadedUrl:
          xRayReportUploadedUrl ?? this.xRayReportUploadedUrl,
      xRayImageRequestStatus:
          xRayImageRequestStatus ?? this.xRayImageRequestStatus,
      xRayReportRequestStatus:
          xRayReportRequestStatus ?? this.xRayReportRequestStatus,
      xRayEditedModel: xRayEditedModel ?? this.xRayEditedModel,
      isEditMode: isEditMode ?? this.isEditMode,
      doctorNames: doctorNames ?? this.doctorNames,
      selectedTreatedDoctor:
          selectedTreatedDoctor ?? this.selectedTreatedDoctor,
      selectedRadiologistDoctorName:
          selectedRadiologistDoctorName ?? this.selectedRadiologistDoctorName,
      hospitalNames: hospitalNames ?? this.hospitalNames,
      labCenters: labCenters ?? this.labCenters,
      selectedLabCenter: selectedLabCenter ?? this.selectedLabCenter,
      selectedHospitalName: selectedHospitalName ?? this.selectedHospitalName,
    );
  }

  @override
  List<Object?> get props => [
        xRayDataEntryStatus,
        message,
        isFormValidated,
        xRayDateSelection,
        xRayBodyPartSelection,
        xRayTypeSelection,
        isXRayPictureSelected,
        bodyPartNames,
        radiologyTypesBasedOnBodyPartNameSelected,
        bodyPartsDataModels,
        puposesOfSelectedXRayType,
        selectedRadiologyTypesOfBodyPartModel,
        countriesNames,
        selectedCountryName,
        selectedPupose,
        xRayPictureUploadedUrl,
        xRayReportUploadedUrl,
        xRayImageRequestStatus,
        xRayReportRequestStatus,
        xRayEditedModel,
        isEditMode,
        doctorNames,
        selectedTreatedDoctor,
        selectedRadiologistDoctorName,
        hospitalNames,
        labCenters,
        selectedLabCenter,
        selectedHospitalName,
      ];
}
