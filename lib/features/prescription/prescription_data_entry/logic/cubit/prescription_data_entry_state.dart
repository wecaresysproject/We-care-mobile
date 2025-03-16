part of 'prescription_data_entry_cubit.dart';

@immutable
class PrescriptionDataEntryState extends Equatable {
  final RequestStatus preceriptionDataEntryStatus;
  final bool isFormValidated;
  final String? preceriptionDateSelection;
  final String? doctorNameSelection;
  final String? doctorSpecialitySelection;
  final bool? isPrescriptionPictureSelected;
  final List<String> countriesNames;
  final List<String> citiesNames;
  final String? selectedCountryName;
  final String? selectedCityName;
  final String? selectedDisease;
  final bool isEditMode;
  final PrescriptionModel? prescribtionEditedModel;

  final String message; // error or success message
  final String prescriptionPictureUploadedUrl;

  final UploadImageRequestStatus prescriptionImageRequestStatus;

  const PrescriptionDataEntryState({
    this.preceriptionDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.preceriptionDateSelection,
    this.doctorNameSelection,
    this.doctorSpecialitySelection,
    this.isPrescriptionPictureSelected,
    this.selectedCountryName,
    this.selectedCityName,
    this.selectedDisease,
    this.countriesNames = const [],
    this.citiesNames = const [],
    this.message = '',
    this.prescriptionPictureUploadedUrl = '',
    this.prescriptionImageRequestStatus = UploadImageRequestStatus.initial,
    this.isEditMode = false,
    this.prescribtionEditedModel,
  }) : super();

  const PrescriptionDataEntryState.initialState()
      : this(
          preceriptionDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          preceriptionDateSelection: null,
          doctorNameSelection: null,
          doctorSpecialitySelection: null,
          isPrescriptionPictureSelected: null,
          selectedCountryName: null,
          selectedCityName: null,
          selectedDisease: null,
          message: '',
          prescriptionImageRequestStatus: UploadImageRequestStatus.initial,
          isEditMode: false,
        );

  PrescriptionDataEntryState copyWith({
    RequestStatus? preceriptionDataEntryStatus,
    String? errorMessage,
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
    String? prescriptionPictureUploadedUrl,
    UploadImageRequestStatus? prescriptionImageRequestStatus,
    String? selectedDisease,
    bool? isEditMode,
    PrescriptionModel? prescribtionEditedModel,
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
      isPrescriptionPictureSelected:
          isPrescriptionPictureSelected ?? this.isPrescriptionPictureSelected,
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
    );
  }

  @override
  List<Object?> get props => [
        preceriptionDataEntryStatus,
        isFormValidated,
        preceriptionDateSelection,
        doctorNameSelection,
        doctorSpecialitySelection,
        isPrescriptionPictureSelected,
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
      ];
}
