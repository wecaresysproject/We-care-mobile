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
  //حادث له آثر
  final bool? hasIncidentEffect; // نعم/لا selection
  final String? incidentType; // نوع الموقف
  final String? incidentDate; // تاريخ الموقف
  final String? incidentEffect; // تأثير الموقف على الحالة النفسية
  //حادث له آثر end

  //هل يوجد حالات نفسية مشابهة فى العائلة؟
  final bool? hasFamilySimilarMentalCases; // نعم/لا selection
  final String? selectedFamilyRelationType;
  //هل يوجد حالات نفسية مشابهة فى العائلة؟ end
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
    this.hasIncidentEffect,
    this.incidentType,
    this.incidentDate,
    this.incidentEffect,
    this.hasFamilySimilarMentalCases,
    this.selectedFamilyRelationType,
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
          hasIncidentEffect: null,
          incidentType: null,
          incidentDate: null,
          incidentEffect: null,
          hasFamilySimilarMentalCases: null,
          selectedFamilyRelationType: null,
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
    bool? hasIncidentEffect,
    String? incidentType,
    String? incidentDate,
    String? incidentEffect,
    bool? hasFamilySimilarMentalCases,
    String? selectedFamilyRelationType,
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
      hasIncidentEffect: hasIncidentEffect ?? this.hasIncidentEffect,
      incidentType: incidentType ?? this.incidentType,
      incidentDate: incidentDate ?? this.incidentDate,
      incidentEffect: incidentEffect ?? this.incidentEffect,
      hasFamilySimilarMentalCases:
          hasFamilySimilarMentalCases ?? this.hasFamilySimilarMentalCases,
      selectedFamilyRelationType:
          selectedFamilyRelationType ?? this.selectedFamilyRelationType,
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
        hasIncidentEffect,
        incidentType,
        incidentDate,
        incidentEffect,
        hasFamilySimilarMentalCases,
        selectedFamilyRelationType,
        isEditMode,
        editDecumentId,
      ];
}
