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
  final NutrationFactsModel? nutrationFactsModel; // NEW: Add nutrition data

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
      ];
}
