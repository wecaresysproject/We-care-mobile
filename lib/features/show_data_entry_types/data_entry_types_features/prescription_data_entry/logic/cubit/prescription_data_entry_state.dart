part of 'prescription_data_entry_cubit.dart';

@immutable
class PrescriptionDataEntryState extends Equatable {
  final RequestStatus preceriptionDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? preceriptionDateSelection;
  final String? doctorNameSelection;
  final String? doctorSpecialitySelection;
  final bool? isPrescriptionPictureSelected;

  const PrescriptionDataEntryState({
    this.preceriptionDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.preceriptionDateSelection,
    this.doctorNameSelection,
    this.doctorSpecialitySelection,
    this.isPrescriptionPictureSelected,
  }) : super();

  const PrescriptionDataEntryState.initialState()
      : this(
          preceriptionDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          preceriptionDateSelection: null,
          doctorNameSelection: null,
          doctorSpecialitySelection: null,
          isPrescriptionPictureSelected: null,
        );

  PrescriptionDataEntryState copyWith({
    RequestStatus? preceriptionDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? preceriptionDateSelection,
    String? doctorNameSelection,
    String? doctorSpecialitySelection,
    bool? isPrescriptionPictureSelected,
  }) {
    return PrescriptionDataEntryState(
      preceriptionDataEntryStatus:
          preceriptionDataEntryStatus ?? this.preceriptionDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      preceriptionDateSelection:
          preceriptionDateSelection ?? this.preceriptionDateSelection,
      doctorNameSelection: doctorNameSelection ?? this.doctorNameSelection,
      doctorSpecialitySelection:
          doctorSpecialitySelection ?? this.doctorSpecialitySelection,
      isPrescriptionPictureSelected:
          isPrescriptionPictureSelected ?? this.isPrescriptionPictureSelected,
    );
  }

  @override
  List<Object?> get props => [
        preceriptionDataEntryStatus,
        errorMessage,
        isFormValidated,
        preceriptionDateSelection,
        doctorNameSelection,
        doctorSpecialitySelection,
        isPrescriptionPictureSelected,
      ];
}
