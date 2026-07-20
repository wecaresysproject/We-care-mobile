part of 'prescription_data_entry_cubit.dart';

@immutable
class PrescriptionDataEntryState extends Equatable {
  final RequestStatus preceriptionDataEntryStatus;
  final bool isFormValidated;
  final String? preceriptionDateSelection;
  final String? doctorNameSelection;
  final String? doctorSpecialitySelection;
  final List<String> countriesNames;
  final List<String> citiesNames;
  final List<String> doctorNames;
  final List<String> doctorSpecialities;
  final List<String> hospitalNames;
  final String? selectedCountryName;
  final String? selectedCityName;
  final String? selectedHospitalName;
  final bool isEditMode;
  final PrescriptionModel? prescribtionEditedModel;

  final String message; // error or success message
  final List<String> prescriptionPictureUploadedUrl;

  final UploadImageRequestStatus prescriptionImageRequestStatus;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const PrescriptionDataEntryState({
    this.preceriptionDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.preceriptionDateSelection,
    this.doctorNameSelection,
    this.doctorSpecialitySelection,
    this.selectedCountryName,
    this.selectedCityName,
    this.selectedHospitalName,
    this.countriesNames = const [],
    this.citiesNames = const [],
    this.doctorNames = const [],
    this.hospitalNames = const [],
    this.message = '',
    this.prescriptionPictureUploadedUrl = const [],
    this.prescriptionImageRequestStatus = UploadImageRequestStatus.initial,
    this.isEditMode = false,
    this.prescribtionEditedModel,
    this.doctorSpecialities = const [],
    this.moduleGuidanceData,
  }) : super();

  const PrescriptionDataEntryState.initialState()
      : this(
          preceriptionDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          preceriptionDateSelection: null,
          doctorNameSelection: null,
          doctorSpecialitySelection: null,
          selectedCountryName: null,
          selectedCityName: null,
          selectedHospitalName: null,
          message: '',
          prescriptionImageRequestStatus: UploadImageRequestStatus.initial,
          isEditMode: false,
          prescribtionEditedModel: null,
          prescriptionPictureUploadedUrl: const [],
          countriesNames: const [],
          citiesNames: const [],
          doctorNames: const [],
          hospitalNames: const [],
          doctorSpecialities: const [],
          moduleGuidanceData: null,
        );

  PrescriptionDataEntryState copyWith({
    RequestStatus? preceriptionDataEntryStatus,
    bool? isFormValidated,
    String? preceriptionDateSelection,
    String? doctorNameSelection,
    String? doctorSpecialitySelection,
    bool? isPrescriptionPictureSelected,
    String? selectedCountryName,
    String? selectedCityName,
    String? selectedHospitalName,
    List<String>? countriesNames,
    String? message,
    List<String>? citiesNames,
    List<String>? hospitalNames,
    List<String>? prescriptionPictureUploadedUrl,
    UploadImageRequestStatus? prescriptionImageRequestStatus,
    bool? isEditMode,
    PrescriptionModel? prescribtionEditedModel,
    List<String>? doctorNames,
    List<String>? doctorSpecialities,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return PrescriptionDataEntryState(
      preceriptionDataEntryStatus:
          preceriptionDataEntryStatus ?? this.preceriptionDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      preceriptionDateSelection:
          preceriptionDateSelection ?? this.preceriptionDateSelection,
      doctorNameSelection: doctorNameSelection ?? this.doctorNameSelection,
      doctorSpecialitySelection:
          doctorSpecialitySelection ?? this.doctorSpecialitySelection,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      countriesNames: countriesNames ?? this.countriesNames,
      message: message ?? this.message,
      citiesNames: citiesNames ?? this.citiesNames,
      hospitalNames: hospitalNames ?? this.hospitalNames,
      selectedCityName: selectedCityName ?? this.selectedCityName,
      selectedHospitalName: selectedHospitalName ?? this.selectedHospitalName,
      prescriptionPictureUploadedUrl:
          prescriptionPictureUploadedUrl ?? this.prescriptionPictureUploadedUrl,
      prescriptionImageRequestStatus:
          prescriptionImageRequestStatus ?? this.prescriptionImageRequestStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      prescribtionEditedModel:
          prescribtionEditedModel ?? this.prescribtionEditedModel,
      doctorNames: doctorNames ?? this.doctorNames,
      doctorSpecialities: doctorSpecialities ?? this.doctorSpecialities,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        preceriptionDataEntryStatus,
        isFormValidated,
        preceriptionDateSelection,
        doctorNameSelection,
        doctorSpecialitySelection,
        selectedCountryName,
        countriesNames,
        message,
        citiesNames,
        hospitalNames,
        selectedCityName,
        selectedHospitalName,
        prescriptionPictureUploadedUrl,
        prescriptionImageRequestStatus,
        isEditMode,
        prescribtionEditedModel,
        doctorNames,
        doctorNames,
        doctorSpecialities,
        moduleGuidanceData
      ];
}
