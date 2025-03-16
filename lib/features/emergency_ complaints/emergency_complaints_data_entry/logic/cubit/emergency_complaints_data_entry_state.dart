part of 'emergency_complaints_data_entry_cubit.dart';

@immutable
class EmergencyComplaintsDataEntryState extends Equatable {
  final RequestStatus emergencyComplaintsDataEntryStatus;
  final bool isFormValidated;
  final String? complaintAppearanceDate;
  final String? doctorNameSelection;
  final String? doctorSpecialitySelection;
  final bool isEditMode;
  final String message; // error or success message

  const EmergencyComplaintsDataEntryState({
    this.emergencyComplaintsDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.complaintAppearanceDate,
    this.doctorNameSelection,
    this.doctorSpecialitySelection,
    this.message = '',
    this.isEditMode = false,
  }) : super();

  const EmergencyComplaintsDataEntryState.initialState()
      : this(
          emergencyComplaintsDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          complaintAppearanceDate: null,
          doctorNameSelection: null,
          doctorSpecialitySelection: null,
          message: '',
          isEditMode: false,
        );

  EmergencyComplaintsDataEntryState copyWith({
    RequestStatus? emergencyComplaintsDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? complaintAppearanceDate,
    String? doctorNameSelection,
    String? doctorSpecialitySelection,
    String? message,
    String? selectedDisease,
    bool? isEditMode,
  }) {
    return EmergencyComplaintsDataEntryState(
      emergencyComplaintsDataEntryStatus: emergencyComplaintsDataEntryStatus ??
          this.emergencyComplaintsDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      complaintAppearanceDate:
          complaintAppearanceDate ?? this.complaintAppearanceDate,
      doctorNameSelection: doctorNameSelection ?? this.doctorNameSelection,
      doctorSpecialitySelection:
          doctorSpecialitySelection ?? this.doctorSpecialitySelection,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        emergencyComplaintsDataEntryStatus,
        isFormValidated,
        complaintAppearanceDate,
        doctorNameSelection,
        doctorSpecialitySelection,
        message,
        isEditMode,
      ];
}
