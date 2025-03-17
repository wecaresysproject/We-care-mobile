part of 'emergency_complaints_data_entry_cubit.dart';

@immutable
class EmergencyComplaintsDataEntryState extends Equatable {
  final RequestStatus emergencyComplaintsDataEntryStatus;
  final bool isFormValidated;
  final String? complaintAppearanceDate;
  final String? complaintLocation;
  final String? symptomsDiseaseRegion; // الاعراض المرضية - المنطقه
  final String? medicalSymptomsIssue; // الاعراض المرضية - الشكوي
  final String? natureOfComplaint; // طبيعة الشكوي
  final String? complaintDegree;
  final String? hasSimilarComplaintBefore;
  final String? isCurrentlyTakingMedication;
  final String? hasReceivedEmergencyCareBefore;

  final bool isEditMode;
  final String message; // error or success message

  const EmergencyComplaintsDataEntryState({
    this.emergencyComplaintsDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.complaintAppearanceDate,
    this.complaintLocation,
    this.symptomsDiseaseRegion,
    this.medicalSymptomsIssue,
    this.natureOfComplaint,
    this.complaintDegree,
    this.hasSimilarComplaintBefore,
    this.isCurrentlyTakingMedication,
    this.hasReceivedEmergencyCareBefore,
    this.message = '',
    this.isEditMode = false,
  }) : super();

  const EmergencyComplaintsDataEntryState.initialState()
      : this(
          emergencyComplaintsDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          complaintAppearanceDate: null,
          complaintLocation: null,
          symptomsDiseaseRegion: null,
          natureOfComplaint: null,
          medicalSymptomsIssue: null,
          complaintDegree: null,
          hasSimilarComplaintBefore: null,
          isCurrentlyTakingMedication: null,
          hasReceivedEmergencyCareBefore: null,
          message: '',
          isEditMode: false,
        );

  EmergencyComplaintsDataEntryState copyWith({
    RequestStatus? emergencyComplaintsDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? complaintAppearanceDate,
    String? complaintLocation,
    String? symptomsDiseaseRegion,
    String? medicalSymptomsIssue,
    String? natureOfComplaint,
    String? complaintDegree,
    String? hasSimilarComplaintBefore,
    String? isCurrentlyTakingMedication,
    String? hasReceivedEmergencyCareBefore,
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
      complaintLocation: complaintLocation ?? this.complaintLocation,
      symptomsDiseaseRegion:
          symptomsDiseaseRegion ?? this.symptomsDiseaseRegion,
      natureOfComplaint: natureOfComplaint ?? this.natureOfComplaint,
      medicalSymptomsIssue: medicalSymptomsIssue ?? this.medicalSymptomsIssue,
      complaintDegree: complaintDegree ?? this.complaintDegree,
      hasSimilarComplaintBefore:
          hasSimilarComplaintBefore ?? this.hasSimilarComplaintBefore,
      isCurrentlyTakingMedication:
          isCurrentlyTakingMedication ?? this.isCurrentlyTakingMedication,
      hasReceivedEmergencyCareBefore:
          hasReceivedEmergencyCareBefore ?? this.hasReceivedEmergencyCareBefore,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        emergencyComplaintsDataEntryStatus,
        isFormValidated,
        complaintAppearanceDate,
        complaintLocation,
        symptomsDiseaseRegion,
        natureOfComplaint,
        medicalSymptomsIssue,
        complaintDegree,
        hasSimilarComplaintBefore,
        isCurrentlyTakingMedication,
        hasReceivedEmergencyCareBefore,
        message,
        isEditMode,
      ];
}
