part of 'nutration_data_entry_cubit.dart';

@immutable
class NutrationDataEntryState extends Equatable {
  final RequestStatus submitNutrationDataStatus;

  final bool isFormValidated;

  final bool isEditMode;
  final bool isListening;
  final String message; // error or success message
  final String recognizedText;
  final int followUpNutrationViewCurrentTabIndex;
  final String selectedPlanDate;
  final SingleNutrientModel? singleNutrientModel;
  final String? genderType;
  final String? selectedPhysicalActivity;
  final List<String> selectedChronicDiseases;
  final List<NutritionElement> nutrationElementsRows;
  final RequestStatus dataTableStatus;

  final List<String> chronicDiseases;
  final List<Day> days;

  final NutrationFactsModel? nutrationFactsModel; // NEW: Add nutrition data
  final bool monthlyActivationStatus;
  final bool weeklyActivationStatus;
  final bool isFoodAnalysisSuccess;
  final bool isAnyPlanActivated;
  final NutritionDefinitionModel? nutritionDefinition;

  // System Prompt Fetching
  final RequestStatus fetchSystemPromptStatus;
  final String systemPrompt;

  const NutrationDataEntryState({
    this.submitNutrationDataStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.isListening = false,
    this.recognizedText = '',
    this.followUpNutrationViewCurrentTabIndex = 0,
    this.nutrationFactsModel,
    this.selectedPlanDate = '',
    this.singleNutrientModel,
    this.genderType = 'ذكر',
    this.selectedPhysicalActivity = 'متوسط',
    this.chronicDiseases = const [],
    this.selectedChronicDiseases = const [],
    this.monthlyActivationStatus = false,
    this.weeklyActivationStatus = false,
    this.days = const [],
    this.isFoodAnalysisSuccess = false,
    this.nutrationElementsRows = const [],
    this.dataTableStatus = RequestStatus.initial,
    this.isAnyPlanActivated = false,
    this.nutritionDefinition,
    this.fetchSystemPromptStatus = RequestStatus.initial,
    this.systemPrompt = '',
  }) : super();

  const NutrationDataEntryState.initialState()
      : this(
          submitNutrationDataStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          isListening: false,
          recognizedText: '',
          followUpNutrationViewCurrentTabIndex: 0,
          nutrationFactsModel: null,
          selectedPlanDate: '',
          singleNutrientModel: null,
          genderType: 'ذكر',
          selectedPhysicalActivity: 'متوسط',
          chronicDiseases: const [],
          selectedChronicDiseases: const [],
          monthlyActivationStatus: false,
          weeklyActivationStatus: false,
          days: const [],
          isFoodAnalysisSuccess: false,
          nutrationElementsRows: const [],
          dataTableStatus: RequestStatus.initial,
          isAnyPlanActivated: false,
          nutritionDefinition: null,
          fetchSystemPromptStatus: RequestStatus.initial,
          systemPrompt: '',
        );

  NutrationDataEntryState copyWith({
    RequestStatus? submitNutrationDataStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    bool? isListening,
    String? recognizedText,
    int? followUpNutrationViewCurrentTabIndex,
    NutrationFactsModel? nutrationFactsModel,
    String? selectedPlanDate,
    SingleNutrientModel? singleNutrientModel,
    String? genderType,
    String? selectedPhysicalActivity,
    List<String>? chronicDiseases,
    List<String>? selectedChronicDiseases,
    bool? monthlyActivationStatus,
    bool? weeklyActivationStatus,
    List<Day>? days,
    bool? isFoodAnalysisSuccess,
    List<NutritionElement>? nutrationElementsRows,
    RequestStatus? dataTableStatus,
    bool? isAnyPlanActivated,
    NutritionDefinitionModel? nutritionDefinition,
    RequestStatus? fetchSystemPromptStatus,
    String? systemPrompt,
  }) {
    return NutrationDataEntryState(
      submitNutrationDataStatus:
          submitNutrationDataStatus ?? this.submitNutrationDataStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      followUpNutrationViewCurrentTabIndex:
          followUpNutrationViewCurrentTabIndex ??
              this.followUpNutrationViewCurrentTabIndex,
      nutrationFactsModel: nutrationFactsModel ?? this.nutrationFactsModel,
      selectedPlanDate: selectedPlanDate ?? this.selectedPlanDate,
      singleNutrientModel: singleNutrientModel ?? this.singleNutrientModel,
      genderType: genderType ?? this.genderType,
      selectedPhysicalActivity:
          selectedPhysicalActivity ?? this.selectedPhysicalActivity,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      selectedChronicDiseases:
          selectedChronicDiseases ?? this.selectedChronicDiseases,
      monthlyActivationStatus:
          monthlyActivationStatus ?? this.monthlyActivationStatus,
      weeklyActivationStatus:
          weeklyActivationStatus ?? this.weeklyActivationStatus,
      days: days ?? this.days,
      isFoodAnalysisSuccess:
          isFoodAnalysisSuccess ?? this.isFoodAnalysisSuccess,
      nutrationElementsRows:
          nutrationElementsRows ?? this.nutrationElementsRows,
      dataTableStatus: dataTableStatus ?? this.dataTableStatus,
      isAnyPlanActivated: isAnyPlanActivated ?? this.isAnyPlanActivated,
      nutritionDefinition: nutritionDefinition ?? this.nutritionDefinition,
      fetchSystemPromptStatus:
          fetchSystemPromptStatus ?? this.fetchSystemPromptStatus,
      systemPrompt: systemPrompt ?? this.systemPrompt,
    );
  }

  @override
  List<Object?> get props => [
        submitNutrationDataStatus,
        isFormValidated,
        isEditMode,
        message,
        isListening,
        recognizedText,
        followUpNutrationViewCurrentTabIndex,
        nutrationFactsModel,
        selectedPlanDate,
        singleNutrientModel,
        genderType,
        selectedPhysicalActivity,
        chronicDiseases,
        selectedChronicDiseases,
        monthlyActivationStatus,
        weeklyActivationStatus,
        days,
        isFoodAnalysisSuccess,
        nutrationElementsRows,
        dataTableStatus,
        isAnyPlanActivated,
        nutritionDefinition,
        fetchSystemPromptStatus,
        systemPrompt,
      ];
}
