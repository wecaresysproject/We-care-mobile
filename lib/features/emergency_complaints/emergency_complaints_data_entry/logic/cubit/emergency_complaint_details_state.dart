part of 'emergency_complaint_details_cubit.dart';

@immutable
class MedicalComplaintDataEntryDetailsState extends Equatable {
  final String? symptomsDiseaseRegion; // الاعراض المرضية - المنطقه
  final String? medicalSymptomsIssue; // الاعراض المرضية - الشكوي
  final String? natureOfComplaint; // طبيعة الشكوي
  final String? complaintDegree;
  final bool isAddNewComplaintFormsValidated;
  final bool isNewComplaintAddedSuccefully;
  final List<String> complaintPlaces;
  final String message; // error or success message
  final List<String> releatedComplaintsToSelectedBodyPartName;

  const MedicalComplaintDataEntryDetailsState({
    this.symptomsDiseaseRegion,
    this.medicalSymptomsIssue,
    this.natureOfComplaint,
    this.complaintDegree,
    this.isAddNewComplaintFormsValidated = false,
    this.isNewComplaintAddedSuccefully = false,
    this.complaintPlaces = const [],
    this.releatedComplaintsToSelectedBodyPartName = const [],
    this.message = '',
  });
  MedicalComplaintDataEntryDetailsState copyWith({
    String? symptomsDiseaseRegion,
    String? medicalSymptomsIssue,
    String? natureOfComplaint,
    String? complaintDegree,
    bool? isAddNewComplaintFormsValidated,
    bool? isNewComplaintAddedSuccefully,
    List<String>? complaintPlaces,
    String? message,
    List<String>? releatedComplaintsToSelectedBodyPartName,
  }) {
    return MedicalComplaintDataEntryDetailsState(
      symptomsDiseaseRegion:
          symptomsDiseaseRegion ?? this.symptomsDiseaseRegion,
      medicalSymptomsIssue: medicalSymptomsIssue ?? this.medicalSymptomsIssue,
      natureOfComplaint: natureOfComplaint ?? this.natureOfComplaint,
      complaintDegree: complaintDegree ?? this.complaintDegree,
      isAddNewComplaintFormsValidated: isAddNewComplaintFormsValidated ??
          this.isAddNewComplaintFormsValidated,
      isNewComplaintAddedSuccefully:
          isNewComplaintAddedSuccefully ?? this.isNewComplaintAddedSuccefully,
      complaintPlaces: complaintPlaces ?? this.complaintPlaces,
      message: message ?? this.message,
      releatedComplaintsToSelectedBodyPartName:
          releatedComplaintsToSelectedBodyPartName ??
              this.releatedComplaintsToSelectedBodyPartName,
    );
  }

  const MedicalComplaintDataEntryDetailsState.initial()
      : this(
          symptomsDiseaseRegion: null,
          natureOfComplaint: null,
          medicalSymptomsIssue: null,
          complaintDegree: null,
          isAddNewComplaintFormsValidated: false,
          isNewComplaintAddedSuccefully: false,
          message: '',
          complaintPlaces: const [],
          releatedComplaintsToSelectedBodyPartName: const [],
        );

  @override
  // TODO: implement props
  List<Object?> get props => [
        symptomsDiseaseRegion,
        medicalSymptomsIssue,
        natureOfComplaint,
        complaintDegree,
        isAddNewComplaintFormsValidated,
        isNewComplaintAddedSuccefully,
        complaintPlaces,
        message,
        releatedComplaintsToSelectedBodyPartName,
      ];
}
