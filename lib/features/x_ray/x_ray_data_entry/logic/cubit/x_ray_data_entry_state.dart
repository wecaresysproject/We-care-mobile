part of 'x_ray_data_entry_cubit.dart';

@immutable
class XRayDataEntryState extends Equatable {
  final RequestStatus xRayDataEntryStatus;
  final List<String> bodyPartNames; // اسماء منطقة الاشعه
  final List<String> radiologyTypesBasedOnBodyPartNameSelected; // نوعية الاشعه
  final List<BodyPartsResponseModel> bodyPartsDataModels;
  final List<String> puposesOfSelectedXRayType; // نوعية الاحتياج للاشعه
  final String? selectedPupose;
  final List<RadiologyTypeOfBodyPartModel>?
      selectedRadiologyTypesOfBodyPartModel;
  final List<String> countriesNames;
  final String message; // error or success message
  final bool isFormValidated;
  final String? xRayDateSelection;
  final String? xRayBodyPartSelection;
  final String? xRayTypeSelection;
  final String? selectedCountryName;
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
      ];
}
