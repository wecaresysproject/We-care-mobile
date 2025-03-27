part of 'emergency_complaints_data_entry_cubit.dart';

@immutable
class EmergencyComplaintsDataEntryState extends Equatable {
  final RequestStatus emergencyComplaintsDataEntryStatus;
  final bool isFormValidated;

  final String? complaintAppearanceDate;
  final String? previousComplaintDate;

  final String? hasSimilarComplaintBefore;
  final String? isCurrentlyTakingMedication;
  final String? hasReceivedEmergencyCareBefore;

  final bool isEditMode;
  final String message; // error or success message
  final bool firstQuestionAnswer;
  final bool secondQuestionAnswer;
  final bool thirdQuestionAnswer;
  //هل عانيت من شكوى مشابهة سابقًا ؟
  final String? complaintDiagnosis; // التشخيص
//هل تتناول أدوية حالية ؟
  final String? medicineName;
  final String? medicineDose;
  //هل أجريت  تدخل طبى طارئ للشكوى ؟
  final String? emergencyInterventionType; // نوع التدخل
  final String? emergencyInterventionDate; // تاريخ التدخل
  final List<MedicalComplaint> medicalComplaints;
  final String updatedDocumentId; // تاريخ التدخل

  const EmergencyComplaintsDataEntryState({
    this.emergencyComplaintsDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.complaintAppearanceDate,
    this.hasSimilarComplaintBefore,
    this.isCurrentlyTakingMedication,
    this.hasReceivedEmergencyCareBefore,
    this.message = '',
    this.isEditMode = false,
    this.firstQuestionAnswer = false,
    this.secondQuestionAnswer = false,
    this.thirdQuestionAnswer = false,
    this.previousComplaintDate,
    this.complaintDiagnosis,
    this.medicineName,
    this.medicineDose,
    this.emergencyInterventionType,
    this.emergencyInterventionDate,
    this.medicalComplaints = const [],
    this.updatedDocumentId = '',
  }) : super();

  const EmergencyComplaintsDataEntryState.initialState()
      : this(
          emergencyComplaintsDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          complaintAppearanceDate: null,
          hasSimilarComplaintBefore: null,
          isCurrentlyTakingMedication: null,
          hasReceivedEmergencyCareBefore: null,
          message: '',
          isEditMode: false,
          firstQuestionAnswer: false,
          secondQuestionAnswer: false,
          thirdQuestionAnswer: false,
          previousComplaintDate: null,
          complaintDiagnosis: null,
          medicineName: null,
          medicineDose: null,
          emergencyInterventionType: null,
          emergencyInterventionDate: null,
          medicalComplaints: const [],
          updatedDocumentId: '',
        );

  EmergencyComplaintsDataEntryState copyWith({
    RequestStatus? emergencyComplaintsDataEntryStatus,
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
    String? complaintDiagnosis,
    String? medicineName,
    String? medicineDose,
    String? emergencyInterventionType,
    String? emergencyInterventionDate,
    List<MedicalComplaint>? medicalComplaints,
    String? updatedDocumentId,
  }) {
    return EmergencyComplaintsDataEntryState(
      emergencyComplaintsDataEntryStatus: emergencyComplaintsDataEntryStatus ??
          this.emergencyComplaintsDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      complaintAppearanceDate:
          complaintAppearanceDate ?? this.complaintAppearanceDate,
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
      complaintDiagnosis: complaintDiagnosis ?? this.complaintDiagnosis,
      medicineName: medicineName ?? this.medicineName,
      medicineDose: medicineDose ?? this.medicineDose,
      emergencyInterventionType:
          emergencyInterventionType ?? this.emergencyInterventionType,
      emergencyInterventionDate:
          emergencyInterventionDate ?? this.emergencyInterventionDate,
      medicalComplaints: medicalComplaints ?? this.medicalComplaints,
      updatedDocumentId: updatedDocumentId ?? this.updatedDocumentId,
    );
  }

  @override
  List<Object?> get props => [
        emergencyComplaintsDataEntryStatus,
        isFormValidated,
        complaintAppearanceDate,
        hasSimilarComplaintBefore,
        isCurrentlyTakingMedication,
        hasReceivedEmergencyCareBefore,
        message,
        isEditMode,
        firstQuestionAnswer,
        secondQuestionAnswer,
        thirdQuestionAnswer,
        previousComplaintDate,
        complaintDiagnosis,
        medicineName,
        medicineDose,
        emergencyInterventionType,
        emergencyInterventionDate,
        medicalComplaints,
        updatedDocumentId,
      ];
}
