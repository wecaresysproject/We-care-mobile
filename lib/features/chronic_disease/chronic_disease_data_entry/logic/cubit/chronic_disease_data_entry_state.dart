part of 'chronic_disease_data_entry_cubit.dart';

@immutable
class ChronicDiseaseDataEntryState extends Equatable {
  final RequestStatus chronicDiseaseDataEntryStatus;
  final bool isFormValidated;
  final String? diagnosisStartDate;
  final String? doctorNameSelection;
  final String? chronicDiseaseName;
  final bool? isPrescriptionPictureSelected;
  final List<String> chronicDiseaseNames;
  final List<String> citiesNames;
  final String? selectedCountryName;
  final String? diseaseStatus;
  final String? selectedMedicationName;
  final bool isEditMode;
  final PrescriptionModel? prescribtionEditedModel;

  final String message; // error or success message
  final String prescriptionPictureUploadedUrl;

  final UploadImageRequestStatus prescriptionImageRequestStatus;
  final List<AddNewMedicineModel> addedNewMedicines;

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
    this.chronicDiseaseNames = const [],
    this.citiesNames = const [],
    this.message = '',
    this.prescriptionPictureUploadedUrl = '',
    this.prescriptionImageRequestStatus = UploadImageRequestStatus.initial,
    this.isEditMode = false,
    this.prescribtionEditedModel,
    this.addedNewMedicines = const [],
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
          addedNewMedicines: const [],
          chronicDiseaseNames: const [],
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
    List<String>? chronicDiseaseNames,
    String? message,
    List<String>? citiesNames,
    String? prescriptionPictureUploadedUrl,
    UploadImageRequestStatus? prescriptionImageRequestStatus,
    String? selectedMedicationName,
    bool? isEditMode,
    PrescriptionModel? prescribtionEditedModel,
    List<AddNewMedicineModel>? addedNewMedicines,
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
      chronicDiseaseNames: chronicDiseaseNames ?? this.chronicDiseaseNames,
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
      addedNewMedicines: addedNewMedicines ?? this.addedNewMedicines,
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
        chronicDiseaseNames,
        message,
        citiesNames,
        diseaseStatus,
        prescriptionPictureUploadedUrl,
        prescriptionImageRequestStatus,
        selectedMedicationName,
        isEditMode,
        prescribtionEditedModel,
        addedNewMedicines,
      ];
}
