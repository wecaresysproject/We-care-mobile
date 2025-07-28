part of 'mental_illnesses_data_entry_cubit.dart';

@immutable
class MedicalIllnessesDataEntryState extends Equatable {
  final RequestStatus mentalIllnessesDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? examinationDate; //تاريخ التشخيص
  final String? selectedMentalIllnessesType; // نوع المرض النفسى/السلوكى
  final String? selectedDiseaseIntensity;
  final String? diseaseDuration; // مدة المرض
  final String? selectedMentalHealthEmergency;
  final String message; // error or success message
  final String? selectedsocialSupport;
  final String? selectedMedicationSideEffects;
  final String? selectedPreferredMentalWellnessActivities;
  final List<String> symptoms;
  final List<TextEditingController> symptomControllers;

  //حادث له آثر
  final bool? hasIncidentEffect; // نعم/لا selection
  final String? selectedIncidentType; // نوع الموقف
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
  final String? treatmentSatisfaction; // رضا عن نتيجة الجلسات
  final String? psychologistName; // الطبيب/الاخصائي النفسي
  final String? selectedCountry; // المركز الدولة
  final String? selectedHospitalName; //المستشفي
  // هل تتلقى العلاج النفسي/الاستشارات؟

  final List<String> mentalIllnessTypes;
  final List<String> medicalSyptoms;
  final List<String> incidentTypes;
  final List<String> medicationImpactOnDailyLife;
  final List<String> psychologicalEmergencies;
  final List<String> medicationSideEffects;
  final List<String> preferredActivitiesForPsychologicalImprovement;
  final List<String> countriesNames;

  final bool isEditMode;
  final String editDecumentId;

  const MedicalIllnessesDataEntryState({
    this.mentalIllnessesDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.examinationDate,
    this.selectedMentalIllnessesType,
    this.selectedDiseaseIntensity,
    this.diseaseDuration, // مدة المرض,
    this.selectedMentalHealthEmergency,
    this.symptoms = const [],
    this.message = '',
    this.selectedsocialSupport,
    this.selectedMedicationSideEffects,
    this.selectedPreferredMentalWellnessActivities,
    this.hasIncidentEffect,
    this.selectedIncidentType,
    this.incidentDate,
    this.incidentEffect,
    this.hasFamilySimilarMentalCases,
    this.selectedFamilyRelationType,
    this.isReceivingPsychologicalTreatment,
    this.psychologicalTreatmentType, // نوع العلاج النفسي/السلوكي
    this.medicationsUsed, // الأدوية المستخدمة
    this.medicationEffectOnLife, // تأثير الأدوية على الحياة اليومية
    this.treatmentSatisfaction, // رضا عن نتيجة الجلسات
    this.psychologistName, // الطبيب/الاخصائي النفسي
    this.selectedCountry, // المركز الدولة
    this.selectedHospitalName, //المستشفي
    this.isEditMode = false,
    this.editDecumentId = '',
    this.mentalIllnessTypes = const [],
    this.medicalSyptoms = const [],
    this.incidentTypes = const [],
    this.medicationImpactOnDailyLife = const [],
    this.psychologicalEmergencies = const [],
    this.medicationSideEffects = const [],
    this.preferredActivitiesForPsychologicalImprovement = const [],
    this.countriesNames = const [],
    this.symptomControllers = const [],
  }) : super();

  MedicalIllnessesDataEntryState.initialState()
      : this(
          mentalIllnessesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          examinationDate: null,
          selectedMentalIllnessesType: null,
          selectedDiseaseIntensity: null,
          diseaseDuration: null, // مدة المرض,
          selectedMentalHealthEmergency: null,
          message: '',
          selectedsocialSupport: null,
          selectedMedicationSideEffects: null,
          selectedPreferredMentalWellnessActivities: null,
          hasIncidentEffect: null,
          selectedIncidentType: null,
          incidentDate: null,
          incidentEffect: null,
          hasFamilySimilarMentalCases: null,
          selectedFamilyRelationType: null,
          isReceivingPsychologicalTreatment: null,
          psychologicalTreatmentType: null,
          medicationsUsed: null,
          medicationEffectOnLife: null,
          treatmentSatisfaction: null,
          psychologistName: null,
          selectedCountry: null,
          selectedHospitalName: null,
          isEditMode: false,
          editDecumentId: '',
          mentalIllnessTypes: const [],
          symptoms: const [],
          medicalSyptoms: const [],
          incidentTypes: const [],
          medicationImpactOnDailyLife: const [],
          psychologicalEmergencies: const [],
          medicationSideEffects: const [],
          preferredActivitiesForPsychologicalImprovement: const [],
          countriesNames: const [],
          symptomControllers: [TextEditingController()],
        );

  MedicalIllnessesDataEntryState copyWith({
    RequestStatus? mentalIllnessesDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? examinationDate,
    String? selectedMentalIllnessesType,
    String? selectedDiseaseIntensity,
    String? diseaseDuration, // مدة المرض,
    String? selectedMentalHealthEmergency,
    String? message,
    String? selectedsocialSupport,
    String? selectedMedicationSideEffects,
    String? selectedPreferredMentalWellnessActivities,
    bool? hasIncidentEffect,
    String? selectedIncidentType,
    String? incidentDate,
    String? incidentEffect,
    bool? hasFamilySimilarMentalCases,
    String? selectedFamilyRelationType,
    bool? isReceivingPsychologicalTreatment,
    String? psychologicalTreatmentType,
    String? medicationsUsed,
    String? medicationEffectOnLife,
    String? treatmentSatisfaction,
    String? psychologistName,
    String? selectedCountry,
    String? selectedHospitalName,
    bool? isEditMode,
    String? editDecumentId,
    List<String>? mentalIllnessTypes,
    List<String>? incidentTypes,
    List<String>? medicationImpactOnDailyLife,
    List<String>? psychologicalEmergencies,
    List<String>? medicationSideEffects,
    List<String>? preferredActivitiesForPsychologicalImprovement,
    List<String>? countriesNames,
    List<String>? symptoms,
    List<TextEditingController>? symptomControllers,
  }) {
    return MedicalIllnessesDataEntryState(
      mentalIllnessesDataEntryStatus:
          mentalIllnessesDataEntryStatus ?? this.mentalIllnessesDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      examinationDate: examinationDate ?? this.examinationDate,
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
      selectedIncidentType: selectedIncidentType ?? this.selectedIncidentType,
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
      treatmentSatisfaction:
          treatmentSatisfaction ?? this.treatmentSatisfaction,
      psychologistName: psychologistName ?? this.psychologistName,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedHospitalName: selectedHospitalName ?? this.selectedHospitalName,
      isEditMode: isEditMode ?? this.isEditMode,
      editDecumentId: editDecumentId ?? this.editDecumentId,
      selectedMentalIllnessesType:
          selectedMentalIllnessesType ?? this.selectedMentalIllnessesType,
      mentalIllnessTypes: mentalIllnessTypes ?? this.mentalIllnessTypes,
      medicalSyptoms: medicalSyptoms ?? medicalSyptoms,
      incidentTypes: incidentTypes ?? this.incidentTypes,
      medicationImpactOnDailyLife:
          medicationImpactOnDailyLife ?? this.medicationImpactOnDailyLife,
      psychologicalEmergencies:
          psychologicalEmergencies ?? this.psychologicalEmergencies,
      medicationSideEffects:
          medicationSideEffects ?? this.medicationSideEffects,
      preferredActivitiesForPsychologicalImprovement:
          preferredActivitiesForPsychologicalImprovement ??
              this.preferredActivitiesForPsychologicalImprovement,
      countriesNames: countriesNames ?? this.countriesNames,
      symptoms: symptoms ?? this.symptoms,
      symptomControllers: symptomControllers ?? this.symptomControllers,
    );
  }

  @override
  List<Object?> get props => [
        mentalIllnessesDataEntryStatus,
        errorMessage,
        isFormValidated,
        examinationDate,
        diseaseDuration, // مدة المرض,
        selectedMentalHealthEmergency,
        message,
        selectedsocialSupport,
        selectedPreferredMentalWellnessActivities,
        selectedMentalIllnessesType,
        selectedDiseaseIntensity,
        selectedMedicationSideEffects,
        hasIncidentEffect,
        selectedIncidentType,
        incidentDate,
        incidentEffect,
        hasFamilySimilarMentalCases,
        selectedFamilyRelationType,
        isReceivingPsychologicalTreatment,
        psychologicalTreatmentType,
        medicationsUsed,
        medicationEffectOnLife,
        treatmentSatisfaction,
        psychologistName,
        selectedCountry,
        selectedHospitalName,
        isEditMode,
        editDecumentId,
        mentalIllnessTypes,
        medicalSyptoms,
        medicationImpactOnDailyLife,
        incidentTypes,
        psychologicalEmergencies,
        medicationSideEffects,
        preferredActivitiesForPsychologicalImprovement,
        countriesNames,
        symptoms,
        symptomControllers,
      ];
}
