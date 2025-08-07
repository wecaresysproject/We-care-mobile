part of 'chronic_disease_data_entry_cubit.dart';

@immutable
class ChronicDiseaseDataEntryState extends Equatable {
  final RequestStatus chronicDiseaseDataEntryStatus;
  final bool isFormValidated;
  final String? diagnosisStartDate;
  final String? doctorNameSelection;
  final String? chronicDiseaseName;
  final bool? isPrescriptionPictureSelected;
  final List<String> countriesNames;
  final List<String> citiesNames;
  final String? selectedCountryName;
  final String? diseaseStatus;
  final String? selectedMedicationName;
  final bool isEditMode;
  final PrescriptionModel? prescribtionEditedModel;

  final String message; // error or success message
  final String prescriptionPictureUploadedUrl;

  final UploadImageRequestStatus prescriptionImageRequestStatus;

  const ChronicDiseaseDataEntryState({
    this.chronicDiseaseDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.diagnosisStartDate,
    this.doctorNameSelection,
    this.chronicDiseaseName,
    this.isPrescriptionPictureSelected,
    this.selectedCountryName,
    this.diseaseStatus,
    this.selectedMedicationName,
    this.countriesNames = const [],
    this.citiesNames = const [],
    this.message = '',
    this.prescriptionPictureUploadedUrl = '',
    this.prescriptionImageRequestStatus = UploadImageRequestStatus.initial,
    this.isEditMode = false,
    this.prescribtionEditedModel,
  }) : super();

  const ChronicDiseaseDataEntryState.initialState()
      : this(
          chronicDiseaseDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          diagnosisStartDate: null,
          doctorNameSelection: null,
          chronicDiseaseName: null,
          isPrescriptionPictureSelected: null,
          selectedCountryName: null,
          diseaseStatus: null,
          selectedMedicationName: null,
          message: '',
          prescriptionImageRequestStatus: UploadImageRequestStatus.initial,
          isEditMode: false,
        );

  ChronicDiseaseDataEntryState copyWith({
    RequestStatus? chronicDiseaseDataEntryStatus,
    bool? isFormValidated,
    String? diagnosisStartDate,
    String? doctorNameSelection,
    String? chronicDiseaseName,
    bool? isPrescriptionPictureSelected,
    String? selectedCountryName,
    String? diseaseStatus,
    List<String>? countriesNames,
    String? message,
    List<String>? citiesNames,
    String? prescriptionPictureUploadedUrl,
    UploadImageRequestStatus? prescriptionImageRequestStatus,
    String? selectedMedicationName,
    bool? isEditMode,
    PrescriptionModel? prescribtionEditedModel,
  }) {
    return ChronicDiseaseDataEntryState(
      chronicDiseaseDataEntryStatus:
          chronicDiseaseDataEntryStatus ?? this.chronicDiseaseDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      diagnosisStartDate: diagnosisStartDate ?? this.diagnosisStartDate,
      doctorNameSelection: doctorNameSelection ?? this.doctorNameSelection,
      chronicDiseaseName: chronicDiseaseName ?? this.chronicDiseaseName,
      isPrescriptionPictureSelected:
          isPrescriptionPictureSelected ?? this.isPrescriptionPictureSelected,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      countriesNames: countriesNames ?? this.countriesNames,
      message: message ?? this.message,
      citiesNames: citiesNames ?? this.citiesNames,
      diseaseStatus: diseaseStatus ?? this.diseaseStatus,
      prescriptionPictureUploadedUrl:
          prescriptionPictureUploadedUrl ?? this.prescriptionPictureUploadedUrl,
      prescriptionImageRequestStatus:
          prescriptionImageRequestStatus ?? this.prescriptionImageRequestStatus,
      selectedMedicationName:
          selectedMedicationName ?? this.selectedMedicationName,
      isEditMode: isEditMode ?? this.isEditMode,
      prescribtionEditedModel:
          prescribtionEditedModel ?? this.prescribtionEditedModel,
    );
  }

  @override
  List<Object?> get props => [
        chronicDiseaseDataEntryStatus,
        isFormValidated,
        diagnosisStartDate,
        doctorNameSelection,
        chronicDiseaseName,
        isPrescriptionPictureSelected,
        selectedCountryName,
        countriesNames,
        message,
        citiesNames,
        diseaseStatus,
        prescriptionPictureUploadedUrl,
        prescriptionImageRequestStatus,
        selectedMedicationName,
        isEditMode,
        prescribtionEditedModel,
      ];
}
