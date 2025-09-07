part of 'nutration_data_entry_cubit.dart';

@immutable
class NutrationDataEntryState extends Equatable {
  final RequestStatus submitNutrationDataStatus;

  final bool isFormValidated;

  final bool isEditMode;
  final bool isListening;
  final String message; // error or success message
  final String recognizedText;

  const NutrationDataEntryState({
    this.submitNutrationDataStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.isListening = false,
    this.recognizedText = '',
  }) : super();

  const NutrationDataEntryState.initialState()
      : this(
          submitNutrationDataStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          isListening: false,
          recognizedText: '',
        );

  NutrationDataEntryState copyWith({
    RequestStatus? submitNutrationDataStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    bool? isListening,
    String? recognizedText,
  }) {
    return NutrationDataEntryState(
      submitNutrationDataStatus:
          submitNutrationDataStatus ?? this.submitNutrationDataStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
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
      ];
}
