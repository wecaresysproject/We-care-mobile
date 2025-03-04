part of 'surgery_data_entry_cubit.dart';

@immutable
class SurgeryDataEntryState extends Equatable {
  final RequestStatus surgeriesDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? surgeryDateSelection;
  final String? surgeryBodyPartSelection;
  final String? surgeryNameSelection;
  final String? xRayTypeSelection;
  final bool? isXRayPictureSelected;

  const SurgeryDataEntryState({
    this.surgeriesDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.surgeryDateSelection,
    this.surgeryBodyPartSelection,
    this.surgeryNameSelection,
    this.xRayTypeSelection,
    this.isXRayPictureSelected,
  }) : super();

  const SurgeryDataEntryState.initialState()
      : this(
          surgeriesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          surgeryDateSelection: null,
          surgeryBodyPartSelection: null,
          surgeryNameSelection: null,
          xRayTypeSelection: null,
          isXRayPictureSelected: null,
        );

  SurgeryDataEntryState copyWith({
    RequestStatus? surgeriesDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? surgeryDateSelection,
    String? surgeryBodyPartSelection,
    String? surgeryNameSelection,
    String? xRayTypeSelection,
    bool? isXRayPictureSelected,
  }) {
    return SurgeryDataEntryState(
      surgeriesDataEntryStatus:
          surgeriesDataEntryStatus ?? this.surgeriesDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      surgeryDateSelection: surgeryDateSelection ?? this.surgeryDateSelection,
      surgeryBodyPartSelection:
          surgeryBodyPartSelection ?? this.surgeryBodyPartSelection,
      surgeryNameSelection: surgeryNameSelection ?? this.surgeryNameSelection,
      xRayTypeSelection: xRayTypeSelection ?? this.xRayTypeSelection,
      isXRayPictureSelected:
          isXRayPictureSelected ?? this.isXRayPictureSelected,
    );
  }

  @override
  List<Object?> get props => [
        surgeriesDataEntryStatus,
        errorMessage,
        isFormValidated,
        surgeryDateSelection,
        surgeryBodyPartSelection,
        surgeryNameSelection,
        xRayTypeSelection,
        isXRayPictureSelected,
      ];
}
