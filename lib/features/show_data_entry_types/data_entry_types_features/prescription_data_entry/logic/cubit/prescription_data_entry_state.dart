part of 'prescription_data_entry_cubit.dart';

@immutable
class PrescriptionDataEntryState extends Equatable {
  final RequestStatus preceriptionDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? preceriptionDateSelection;
  final String? xRayBodyPartSelection;
  final String? xRayTypeSelection;
  final bool? isXRayPictureSelected;

  const PrescriptionDataEntryState({
    this.preceriptionDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.preceriptionDateSelection,
    this.xRayBodyPartSelection,
    this.xRayTypeSelection,
    this.isXRayPictureSelected,
  }) : super();

  const PrescriptionDataEntryState.initialState()
      : this(
          preceriptionDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          preceriptionDateSelection: null,
          xRayBodyPartSelection: null,
          xRayTypeSelection: null,
          isXRayPictureSelected: null,
        );

  PrescriptionDataEntryState copyWith({
    RequestStatus? preceriptionDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? preceriptionDateSelection,
    String? xRayBodyPartSelection,
    String? xRayTypeSelection,
    bool? isXRayPictureSelected,
  }) {
    return PrescriptionDataEntryState(
      preceriptionDataEntryStatus:
          preceriptionDataEntryStatus ?? this.preceriptionDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      preceriptionDateSelection:
          preceriptionDateSelection ?? this.preceriptionDateSelection,
      xRayBodyPartSelection:
          xRayBodyPartSelection ?? this.xRayBodyPartSelection,
      xRayTypeSelection: xRayTypeSelection ?? this.xRayTypeSelection,
      isXRayPictureSelected:
          isXRayPictureSelected ?? this.isXRayPictureSelected,
    );
  }

  @override
  List<Object?> get props => [
        preceriptionDataEntryStatus,
        errorMessage,
        isFormValidated,
        preceriptionDateSelection,
        xRayBodyPartSelection,
        xRayTypeSelection,
        isXRayPictureSelected,
      ];
}
