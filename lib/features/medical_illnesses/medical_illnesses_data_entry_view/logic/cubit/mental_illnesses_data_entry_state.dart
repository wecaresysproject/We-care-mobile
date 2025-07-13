part of 'mental_illnesses_data_entry_cubit.dart';

@immutable
class MedicalIllnessesDataEntryState extends Equatable {
  final RequestStatus mentalIllnessesDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? examinationDate; //تاريخ التشخيص
  final String? mentalIllnessesType; // نوع المرض النفسى/السلوكى
  final String? selectedMedicalSyptoms; // الأعراض المرضية
  final String? selectedDiseaseIntensity;
  final String? diseaseDuration; // مدة المرض
  final String? selectedMentalHealthEmergency;
  final String message; // error or success message
  final String? selectedsocialSupport;
  final String? selectedMedicationSideEffects;
  final String? selectedPreferredMentalWellnessActivities;
  final bool isEditMode;
  final String editDecumentId;

  const MedicalIllnessesDataEntryState({
    this.mentalIllnessesDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.examinationDate,
    this.mentalIllnessesType,
    this.selectedMedicalSyptoms,
    this.selectedDiseaseIntensity,
    this.diseaseDuration, // مدة المرض,
    this.selectedMentalHealthEmergency,
    this.message = '',
    this.selectedsocialSupport,
    this.selectedMedicationSideEffects,
    this.selectedPreferredMentalWellnessActivities,
    this.isEditMode = false,
    this.editDecumentId = '',
  }) : super();

  const MedicalIllnessesDataEntryState.initialState()
      : this(
          mentalIllnessesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          examinationDate: null,
          mentalIllnessesType: null,
          selectedMedicalSyptoms: null,
          selectedDiseaseIntensity: null,
          diseaseDuration: null, // مدة المرض,
          selectedMentalHealthEmergency: null,
          message: '',
          selectedsocialSupport: null,
          selectedMedicationSideEffects: null,
          selectedPreferredMentalWellnessActivities: null,

          isEditMode: false,
          editDecumentId: '',
        );

  MedicalIllnessesDataEntryState copyWith({
    RequestStatus? mentalIllnessesDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? examinationDate,
    String? mentalIllnessesType,
    String? selectedMedicalSyptoms,
    String? selectedDiseaseIntensity,
    String? diseaseDuration, // مدة المرض,
    String? selectedMentalHealthEmergency,
    String? message,
    String? selectedsocialSupport,
    String? selectedMedicationSideEffects,
    String? selectedPreferredMentalWellnessActivities,
    bool? isEditMode,
    String? editDecumentId,
  }) {
    return MedicalIllnessesDataEntryState(
      mentalIllnessesDataEntryStatus:
          mentalIllnessesDataEntryStatus ?? this.mentalIllnessesDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      examinationDate: examinationDate ?? this.examinationDate,
      selectedMedicalSyptoms:
          selectedMedicalSyptoms ?? this.selectedMedicalSyptoms,
      selectedDiseaseIntensity:
          selectedDiseaseIntensity ?? this.selectedDiseaseIntensity,
      diseaseDuration: diseaseDuration ?? this.diseaseDuration,
      selectedMentalHealthEmergency:
          selectedMentalHealthEmergency ?? this.selectedMentalHealthEmergency,
      message: message ?? this.message,
      selectedsocialSupport:
          selectedsocialSupport ?? this.selectedsocialSupport,
      selectedPreferredMentalWellnessActivities:
          selectedPreferredMentalWellnessActivities ??
              this.selectedPreferredMentalWellnessActivities,
      selectedMedicationSideEffects:
          selectedMedicationSideEffects ?? this.selectedMedicationSideEffects,
      isEditMode: isEditMode ?? this.isEditMode,
      editDecumentId: editDecumentId ?? this.editDecumentId,
      mentalIllnessesType: mentalIllnessesType ?? this.mentalIllnessesType,
    );
  }

  @override
  List<Object?> get props => [
        mentalIllnessesDataEntryStatus,
        errorMessage,
        isFormValidated,
        examinationDate,
        selectedMedicalSyptoms,
        diseaseDuration, // مدة المرض,
        selectedMentalHealthEmergency,
        message,
        selectedsocialSupport,
        selectedPreferredMentalWellnessActivities,
        mentalIllnessesType,
        selectedDiseaseIntensity,
        selectedMedicationSideEffects,
        isEditMode,
        editDecumentId,
      ];
}
