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
  final String? diseaseStatus;
  final String? selectedMedicationName;
  final bool isEditMode;
  final PostChronicDiseaseModel? chronincDiseaseEditedModel;

  final String message; // error or success message
  final String prescriptionPictureUploadedUrl;

  final UploadImageRequestStatus prescriptionImageRequestStatus;
  final List<AddNewMedicineModel> addedNewMedicines;
  final String documentId;

  const ChronicDiseaseDataEntryState({
    this.chronicDiseaseDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.diagnosisStartDate,
    this.doctorNameSelection,
    this.chronicDiseaseName,
    this.isPrescriptionPictureSelected,
    this.diseaseStatus,
    this.selectedMedicationName,
    this.chronicDiseaseNames = const [],
    this.message = '',
    this.prescriptionPictureUploadedUrl = '',
    this.prescriptionImageRequestStatus = UploadImageRequestStatus.initial,
    this.isEditMode = false,
    this.chronincDiseaseEditedModel,
    this.addedNewMedicines = const [],
    this.documentId = '',
  }) : super();

  const ChronicDiseaseDataEntryState.initialState()
      : this(
          chronicDiseaseDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          diagnosisStartDate: null,
          doctorNameSelection: null,
          chronicDiseaseName: null,
          diseaseStatus: null,
          selectedMedicationName: null,
          message: '',
          prescriptionImageRequestStatus: UploadImageRequestStatus.initial,
          isEditMode: false,
          addedNewMedicines: const [],
          chronicDiseaseNames: const [],
          documentId: '',
        );

  ChronicDiseaseDataEntryState copyWith({
    RequestStatus? chronicDiseaseDataEntryStatus,
    bool? isFormValidated,
    String? diagnosisStartDate,
    String? doctorNameSelection,
    String? chronicDiseaseName,
    String? diseaseStatus,
    List<String>? chronicDiseaseNames,
    String? message,
    String? selectedMedicationName,
    bool? isEditMode,
    PostChronicDiseaseModel? chronincDiseaseEditedModel,
    List<AddNewMedicineModel>? addedNewMedicines,
    String? documentId,
  }) {
    return ChronicDiseaseDataEntryState(
      chronicDiseaseDataEntryStatus:
          chronicDiseaseDataEntryStatus ?? this.chronicDiseaseDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      diagnosisStartDate: diagnosisStartDate ?? this.diagnosisStartDate,
      doctorNameSelection: doctorNameSelection ?? this.doctorNameSelection,
      chronicDiseaseName: chronicDiseaseName ?? this.chronicDiseaseName,
      chronicDiseaseNames: chronicDiseaseNames ?? this.chronicDiseaseNames,
      message: message ?? this.message,
      diseaseStatus: diseaseStatus ?? this.diseaseStatus,
      selectedMedicationName:
          selectedMedicationName ?? this.selectedMedicationName,
      isEditMode: isEditMode ?? this.isEditMode,
      chronincDiseaseEditedModel:
          chronincDiseaseEditedModel ?? this.chronincDiseaseEditedModel,
      addedNewMedicines: addedNewMedicines ?? this.addedNewMedicines,
      documentId: documentId ?? this.documentId,
    );
  }

  @override
  List<Object?> get props => [
        chronicDiseaseDataEntryStatus,
        isFormValidated,
        diagnosisStartDate,
        doctorNameSelection,
        chronicDiseaseName,
        chronicDiseaseNames,
        message,
        diseaseStatus,
        selectedMedicationName,
        isEditMode,
        chronincDiseaseEditedModel,
        addedNewMedicines,
        documentId,
      ];
}
