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
  final String? genderType;
  final String? selectedPhysicalActivity;
  final List<String> selectedChronicDiseases;
  final List<String> chronicDiseases;
  final List<Day> days;

  final NutrationFactsModel? nutrationFactsModel; // NEW: Add nutrition data
  final bool monthlyActivationStatus;
  final bool weeklyActivationStatus;

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
    this.genderType = '',
    this.selectedPhysicalActivity = '',
    this.chronicDiseases = const [],
    this.selectedChronicDiseases = const [],
    this.monthlyActivationStatus = false,
    this.weeklyActivationStatus = false,
    this.days = const [],
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
          genderType: '',
          selectedPhysicalActivity: '',
          chronicDiseases: const [],
          selectedChronicDiseases: const [],
          monthlyActivationStatus: false,
          weeklyActivationStatus: false,
          days: const [],
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
    String? genderType,
    String? selectedPhysicalActivity,
    List<String>? chronicDiseases,
    List<String>? selectedChronicDiseases,
    bool? monthlyActivationStatus,
    bool? weeklyActivationStatus,
    List<Day>? days,
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
        genderType,
        selectedPhysicalActivity,
        chronicDiseases,
        selectedChronicDiseases,
        monthlyActivationStatus,
        weeklyActivationStatus,
        days,
      ];
}
