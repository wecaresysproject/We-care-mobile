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
  final List<String> diseasesNames;
  final String? selectedCountryName;
  final String? selectedCityName;
  final String? selectedDisease;
  final bool isEditMode;
  final PrescriptionModel? prescribtionEditedModel;

  final String message; // error or success message
  final List<String> prescriptionPictureUploadedUrl;

  final UploadImageRequestStatus prescriptionImageRequestStatus;

  const PrescriptionDataEntryState({
    this.preceriptionDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.preceriptionDateSelection,
    this.doctorNameSelection,
    this.doctorSpecialitySelection,
    this.selectedCountryName,
    this.selectedCityName,
    this.selectedDisease,
    this.countriesNames = const [],
    this.citiesNames = const [],
    this.doctorNames = const [],
    this.message = '',
    this.prescriptionPictureUploadedUrl = const [],
    this.prescriptionImageRequestStatus = UploadImageRequestStatus.initial,
    this.isEditMode = false,
    this.prescribtionEditedModel,
    this.diseasesNames = const [],
    this.doctorSpecialities = const [],
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
          selectedDisease: null,
          message: '',
          prescriptionImageRequestStatus: UploadImageRequestStatus.initial,
          isEditMode: false,
          prescribtionEditedModel: null,
          prescriptionPictureUploadedUrl: const [],
          countriesNames: const [],
          citiesNames: const [],
          doctorNames: const [],
          diseasesNames: const [],
          doctorSpecialities: const [],
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
    List<String>? countriesNames,
    String? message,
    List<String>? citiesNames,
    List<String>? prescriptionPictureUploadedUrl,
    UploadImageRequestStatus? prescriptionImageRequestStatus,
    String? selectedDisease,
    bool? isEditMode,
    PrescriptionModel? prescribtionEditedModel,
    List<String>? doctorNames,
    List<String>? diseasesNames,
    List<String>? doctorSpecialities,
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
      selectedCityName: selectedCityName ?? this.selectedCityName,
      prescriptionPictureUploadedUrl:
          prescriptionPictureUploadedUrl ?? this.prescriptionPictureUploadedUrl,
      prescriptionImageRequestStatus:
          prescriptionImageRequestStatus ?? this.prescriptionImageRequestStatus,
      selectedDisease: selectedDisease ?? this.selectedDisease,
      isEditMode: isEditMode ?? this.isEditMode,
      prescribtionEditedModel:
          prescribtionEditedModel ?? this.prescribtionEditedModel,
      doctorNames: doctorNames ?? this.doctorNames,
      diseasesNames: diseasesNames ?? this.diseasesNames,
      doctorSpecialities: doctorSpecialities ?? this.doctorSpecialities,
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
        selectedCityName,
        prescriptionPictureUploadedUrl,
        prescriptionImageRequestStatus,
        selectedDisease,
        isEditMode,
        prescribtionEditedModel,
        doctorNames,
        diseasesNames,
        doctorSpecialities,
      ];
}
