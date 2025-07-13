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

// هل تتلقى العلاج النفسي/الاستشارات؟
  final bool? isReceivingPsychologicalTreatment;
  final String? psychologicalTreatmentType; // نوع العلاج النفسي/السلوكي
  final String? medicationsUsed; // الأدوية المستخدمة
  final String? medicationEffectOnLife; // تأثير الأدوية على الحياة اليومية
  final String? numberOfSessions; // عدد الجلسات النفسية
  final String? treatmentSatisfaction; // رضا عن نتيجة الجلسات
  final String? psychologistName; // الطبيب/الاخصائي النفسي
  final String? selectedCountry; // المركز الدولة
  final String? selectedHospitalName; //المستشفي
  // هل تتلقى العلاج النفسي/الاستشارات؟

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
    this.isReceivingPsychologicalTreatment,
    this.psychologicalTreatmentType, // نوع العلاج النفسي/السلوكي
    this.medicationsUsed, // الأدوية المستخدمة
    this.medicationEffectOnLife, // تأثير الأدوية على الحياة اليومية
    this.numberOfSessions, // عدد الجلسات النفسية
    this.treatmentSatisfaction, // رضا عن نتيجة الجلسات
    this.psychologistName, // الطبيب/الاخصائي النفسي
    this.selectedCountry, // المركز الدولة
    this.selectedHospitalName, //المستشفي
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
          isReceivingPsychologicalTreatment: null,
          psychologicalTreatmentType: null,
          medicationsUsed: null,
          medicationEffectOnLife: null,
          numberOfSessions: null,
          treatmentSatisfaction: null,
          psychologistName: null,
          selectedCountry: null,
          selectedHospitalName: null,
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
    bool? isReceivingPsychologicalTreatment,
    String? psychologicalTreatmentType,
    String? medicationsUsed,
    String? medicationEffectOnLife,
    String? numberOfSessions,
    String? treatmentSatisfaction,
    String? psychologistName,
    String? selectedCountry,
    String? selectedHospitalName,
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
      isReceivingPsychologicalTreatment: isReceivingPsychologicalTreatment ??
          this.isReceivingPsychologicalTreatment,
      psychologicalTreatmentType:
          psychologicalTreatmentType ?? this.psychologicalTreatmentType,
      medicationsUsed: medicationsUsed ?? this.medicationsUsed,
      medicationEffectOnLife:
          medicationEffectOnLife ?? this.medicationEffectOnLife,
      numberOfSessions: numberOfSessions ?? this.numberOfSessions,
      treatmentSatisfaction:
          treatmentSatisfaction ?? this.treatmentSatisfaction,
      psychologistName: psychologistName ?? this.psychologistName,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedHospitalName: selectedHospitalName ?? this.selectedHospitalName,
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
        isReceivingPsychologicalTreatment,
        psychologicalTreatmentType,
        medicationsUsed,
        medicationEffectOnLife,
        numberOfSessions,
        treatmentSatisfaction,
        psychologistName,
        selectedCountry,
        selectedHospitalName,
        isEditMode,
        editDecumentId,
      ];
}
