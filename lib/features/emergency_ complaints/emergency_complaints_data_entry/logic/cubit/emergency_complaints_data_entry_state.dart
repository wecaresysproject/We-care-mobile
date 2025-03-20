part of 'emergency_complaints_data_entry_cubit.dart';

@immutable
class EmergencyComplaintsDataEntryState extends Equatable {
  final RequestStatus emergencyComplaintsDataEntryStatus;
  final bool isFormValidated;
  final bool isAddNewComplaintFormsValidated;
  final bool isNewComplaintAddedSuccefully;
  final String? complaintAppearanceDate;
  final String? previousComplaintDate;
  final String? symptomsDiseaseRegion; // الاعراض المرضية - المنطقه
  final String? medicalSymptomsIssue; // الاعراض المرضية - الشكوي
  final String? natureOfComplaint; // طبيعة الشكوي
  final String? complaintDegree;
  final String? hasSimilarComplaintBefore;
  final String? isCurrentlyTakingMedication;
  final String? hasReceivedEmergencyCareBefore;
  final List<String> complaintPlaces;

  final bool isEditMode;
  final String message; // error or success message
  final bool firstQuestionAnswer;
  final bool secondQuestionAnswer;
  final bool thirdQuestionAnswer;

  const EmergencyComplaintsDataEntryState({
    this.emergencyComplaintsDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.isAddNewComplaintFormsValidated = false,
    this.isNewComplaintAddedSuccefully = false,
    this.complaintAppearanceDate,
    this.symptomsDiseaseRegion,
    this.medicalSymptomsIssue,
    this.natureOfComplaint,
    this.complaintDegree,
    this.hasSimilarComplaintBefore,
    this.isCurrentlyTakingMedication,
    this.hasReceivedEmergencyCareBefore,
    this.message = '',
    this.isEditMode = false,
    this.firstQuestionAnswer = false,
    this.secondQuestionAnswer = false,
    this.thirdQuestionAnswer = false,
    this.previousComplaintDate,
    this.complaintPlaces = const [],
  }) : super();

  const EmergencyComplaintsDataEntryState.initialState()
      : this(
          emergencyComplaintsDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          isAddNewComplaintFormsValidated: false,
          isNewComplaintAddedSuccefully: false,
          complaintAppearanceDate: null,
          symptomsDiseaseRegion: null,
          natureOfComplaint: null,
          medicalSymptomsIssue: null,
          complaintDegree: null,
          hasSimilarComplaintBefore: null,
          isCurrentlyTakingMedication: null,
          hasReceivedEmergencyCareBefore: null,
          message: '',
          isEditMode: false,
          firstQuestionAnswer: false,
          secondQuestionAnswer: false,
          thirdQuestionAnswer: false,
          previousComplaintDate: null,
        );

  EmergencyComplaintsDataEntryState copyWith({
    RequestStatus? emergencyComplaintsDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? complaintAppearanceDate,
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
    bool? firstQuestionAnswer,
    bool? secondQuestionAnswer,
    bool? thirdQuestionAnswer,
    String? previousComplaintDate,
    bool? isAddNewComplaintFormsValidated,
    bool? isNewComplaintAddedSuccefully,
    List<String>? complaintPlaces,
  }) {
    return EmergencyComplaintsDataEntryState(
      emergencyComplaintsDataEntryStatus: emergencyComplaintsDataEntryStatus ??
          this.emergencyComplaintsDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      isAddNewComplaintFormsValidated: isAddNewComplaintFormsValidated ??
          this.isAddNewComplaintFormsValidated,
      complaintAppearanceDate:
          complaintAppearanceDate ?? this.complaintAppearanceDate,
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
      firstQuestionAnswer: firstQuestionAnswer ?? this.firstQuestionAnswer,
      secondQuestionAnswer: secondQuestionAnswer ?? this.secondQuestionAnswer,
      thirdQuestionAnswer: thirdQuestionAnswer ?? this.thirdQuestionAnswer,
      previousComplaintDate:
          previousComplaintDate ?? this.previousComplaintDate,
      isNewComplaintAddedSuccefully:
          isNewComplaintAddedSuccefully ?? this.isNewComplaintAddedSuccefully,
      complaintPlaces: complaintPlaces ?? this.complaintPlaces,
    );
  }

  @override
  List<Object?> get props => [
        emergencyComplaintsDataEntryStatus,
        isFormValidated,
        isAddNewComplaintFormsValidated,
        complaintAppearanceDate,
        symptomsDiseaseRegion,
        natureOfComplaint,
        medicalSymptomsIssue,
        complaintDegree,
        hasSimilarComplaintBefore,
        isCurrentlyTakingMedication,
        hasReceivedEmergencyCareBefore,
        message,
        isEditMode,
        firstQuestionAnswer,
        secondQuestionAnswer,
        thirdQuestionAnswer,
        previousComplaintDate,
        isNewComplaintAddedSuccefully,
        complaintPlaces,
      ];
}
