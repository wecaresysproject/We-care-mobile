part of 'x_ray_data_entry_cubit.dart';

enum RequestStatus { initial, loading, success, failure }

@immutable
class XRayDataEntryState extends Equatable {
  final RequestStatus xRayDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? xRayDateSelection;
  final String? xRayBodyPartSelection;
  final String? xRayTypeSelection;
  final bool? isXRayPictureSelected;

  const XRayDataEntryState({
    this.xRayDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.xRayDateSelection,
    this.xRayBodyPartSelection,
    this.xRayTypeSelection,
    this.isXRayPictureSelected,
  }) : super();

  const XRayDataEntryState.initialState()
      : this(
          xRayDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          xRayDateSelection: null,
          xRayBodyPartSelection: null,
          xRayTypeSelection: null,
          isXRayPictureSelected: null,
        );

  XRayDataEntryState copyWith({
    RequestStatus? xRayDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? xRayDateSelection,
    String? xRayBodyPartSelection,
    String? xRayTypeSelection,
    bool? isXRayPictureSelected,
  }) {
    return XRayDataEntryState(
      xRayDataEntryStatus: xRayDataEntryStatus ?? this.xRayDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      xRayDateSelection: xRayDateSelection ?? this.xRayDateSelection,
      xRayBodyPartSelection:
          xRayBodyPartSelection ?? this.xRayBodyPartSelection,
      xRayTypeSelection: xRayTypeSelection ?? this.xRayTypeSelection,
      isXRayPictureSelected:
          isXRayPictureSelected ?? this.isXRayPictureSelected,
    );
  }

  @override
  List<Object?> get props => [
        xRayDataEntryStatus,
        errorMessage,
        isFormValidated,
        xRayDateSelection,
        xRayBodyPartSelection,
        xRayTypeSelection,
        isXRayPictureSelected,
      ];
}
