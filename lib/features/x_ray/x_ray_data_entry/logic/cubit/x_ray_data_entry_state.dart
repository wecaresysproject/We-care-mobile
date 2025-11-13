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
  final String? selectedRadiologyCenter;
  final List<RadiologyTypeOfBodyPartModel>?
      selectedRadiologyTypesOfBodyPartModel;
  final List<String> countriesNames;
  final List<String> hospitalNames;
  final List<String> radilogyCenters;
  final List<String> doctorNames;
  final List<String> radiologyDoctors;
  final String message; // error or success message
  final bool isFormValidated;
  final String? xRayDateSelection;
  final String? xRayBodyPartSelection;
  final String? xRayTypeSelection;
  final String? selectedCountryName;
  final String? selectedTreatedDoctor;
  final String? selectedRadiologistDoctorName;
  final String? symptomsRequiringIntervention; // الاعراض المستدعية للاعراض
  final UploadImageRequestStatus xRayImageRequestStatus;
  final UploadReportRequestStatus xRayReportRequestStatus;
  final RadiologyData? xRayEditedModel;
  final bool isEditMode;
  final List<String> uploadedTestImages; // URLs returned from API
  final List<String> uploadedTestReports;

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
    this.selectedRadiologyTypesOfBodyPartModel,
    this.xRayImageRequestStatus = UploadImageRequestStatus.initial,
    this.xRayReportRequestStatus = UploadReportRequestStatus.initial,
    this.xRayEditedModel,
    this.isEditMode = false,
    this.doctorNames = const [],
    this.selectedTreatedDoctor,
    this.selectedRadiologistDoctorName,
    this.hospitalNames = const [],
    this.radilogyCenters = const [],
    this.selectedRadiologyCenter,
    this.selectedHospitalName,
    this.uploadedTestImages = const [],
    this.uploadedTestReports = const [],
    this.radiologyDoctors = const [],
    this.symptomsRequiringIntervention,
  }) : super();

  const XRayDataEntryState.initialState()
      : this(
          xRayDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          xRayDateSelection: null,
          xRayBodyPartSelection: null,
          xRayTypeSelection: null,
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
          radilogyCenters: const [],
          selectedRadiologyCenter: null,
          selectedHospitalName: null,
          uploadedTestImages: const [],
          uploadedTestReports: const [],
          radiologyDoctors: const [],
          symptomsRequiringIntervention: null,
        );

  XRayDataEntryState copyWith({
    RequestStatus? xRayDataEntryStatus,
    bool? isFormValidated,
    String? xRayDateSelection,
    String? xRayBodyPartSelection,
    String? xRayTypeSelection,
    List<String>? bodyPartNames,
    List<String>? radiologyTypesBasedOnBodyPartNameSelected,
    List<BodyPartsResponseModel>? bodyPartsDataModels,
    List<String>? puposesOfSelectedXRayType,
    List<RadiologyTypeOfBodyPartModel>? selectedRadiologyTypesOfBodyPartModel,
    List<String>? countriesNames,
    String? selectedCountryName,
    String? selectedPupose,
    String? message,
    UploadImageRequestStatus? xRayImageRequestStatus,
    UploadReportRequestStatus? xRayReportRequestStatus,
    RadiologyData? xRayEditedModel,
    bool? isEditMode,
    List<String>? doctorNames,
    String? selectedTreatedDoctor,
    String? selectedRadiologistDoctorName,
    List<String>? hospitalNames,
    List<String>? radilogyCenters,
    String? selectedRadiologyCenter,
    String? selectedHospitalName,
    List<String>? uploadedTestImages,
    List<String>? uploadedTestReports,
    List<String>? radiologyDoctors,
    String? symptomsRequiringIntervention,
  }) {
    return XRayDataEntryState(
      xRayDataEntryStatus: xRayDataEntryStatus ?? this.xRayDataEntryStatus,
      message: message ?? this.message,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      xRayDateSelection: xRayDateSelection ?? this.xRayDateSelection,
      xRayBodyPartSelection:
          xRayBodyPartSelection ?? this.xRayBodyPartSelection,
      xRayTypeSelection: xRayTypeSelection ?? this.xRayTypeSelection,
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
      radilogyCenters: radilogyCenters ?? this.radilogyCenters,
      selectedRadiologyCenter:
          selectedRadiologyCenter ?? this.selectedRadiologyCenter,
      selectedHospitalName: selectedHospitalName ?? this.selectedHospitalName,
      uploadedTestImages: uploadedTestImages ?? this.uploadedTestImages,
      uploadedTestReports: uploadedTestReports ?? this.uploadedTestReports,
      radiologyDoctors: radiologyDoctors ?? this.radiologyDoctors,
      symptomsRequiringIntervention:
          symptomsRequiringIntervention ?? this.symptomsRequiringIntervention,
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
        bodyPartNames,
        radiologyTypesBasedOnBodyPartNameSelected,
        bodyPartsDataModels,
        puposesOfSelectedXRayType,
        selectedRadiologyTypesOfBodyPartModel,
        countriesNames,
        selectedCountryName,
        selectedPupose,
        xRayImageRequestStatus,
        xRayReportRequestStatus,
        xRayEditedModel,
        isEditMode,
        doctorNames,
        selectedTreatedDoctor,
        selectedRadiologistDoctorName,
        hospitalNames,
        radilogyCenters,
        selectedRadiologyCenter,
        selectedHospitalName,
        uploadedTestImages,
        uploadedTestReports,
        radiologyDoctors,
        symptomsRequiringIntervention,
      ];
}
