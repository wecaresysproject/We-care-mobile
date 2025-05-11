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
  final List<String>
      releatedComplaintsToSelectedBodyPartName; // الاعراض المرضية - الشكوي
  final bool isEditingComplaint;
  final bool isEditingComplaintSuccess;
  final List<String>
      complaintPlacesRelativeToMainRegion; // الاعراض المرضية - العضو/الجزء
  final OptionsLoadingState complaintPlacesRelativeToMainRegionLoadingState;
  final String?
      selectedOrganOrPartSymptom; // الاعراض المرضية - العضو/الجزء  => الجزء المختار
  final OptionsLoadingState mainRegionComplainsLoadingState;
  final List<BodySymptom> bodySyptomsResults;
  final SearchResultState searchResultState;

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
    this.isEditingComplaint = false,
    this.isEditingComplaintSuccess = false,
    this.complaintPlacesRelativeToMainRegion = const [],
    this.selectedOrganOrPartSymptom,
    this.mainRegionComplainsLoadingState = OptionsLoadingState.loading,
    this.complaintPlacesRelativeToMainRegionLoadingState =
        OptionsLoadingState.loading,
    this.bodySyptomsResults = const [],
    this.searchResultState = SearchResultState.initial,
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
    bool? isEditingComplaint,
    bool? isEditingComplaintSuccess,
    List<String>? complaintPlacesRelativeToMainRegion,
    String? selectedOrganOrPartSymptom,
    OptionsLoadingState? mainRegionComplainsLoadingState,
    OptionsLoadingState? complaintPlacesRelativeToMainRegionLoadingState,
    List<BodySymptom>? bodySyptomsResults,
    SearchResultState? searchResultState,
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
      isEditingComplaint: isEditingComplaint ?? this.isEditingComplaint,
      isEditingComplaintSuccess:
          isEditingComplaintSuccess ?? this.isEditingComplaintSuccess,
      complaintPlacesRelativeToMainRegion:
          complaintPlacesRelativeToMainRegion ??
              this.complaintPlacesRelativeToMainRegion,
      selectedOrganOrPartSymptom:
          selectedOrganOrPartSymptom ?? this.selectedOrganOrPartSymptom,
      mainRegionComplainsLoadingState: mainRegionComplainsLoadingState ??
          this.mainRegionComplainsLoadingState,
      complaintPlacesRelativeToMainRegionLoadingState:
          complaintPlacesRelativeToMainRegionLoadingState ??
              this.complaintPlacesRelativeToMainRegionLoadingState,
      bodySyptomsResults: bodySyptomsResults ?? this.bodySyptomsResults,
      searchResultState: searchResultState ?? this.searchResultState,
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
          isEditingComplaint: false,
          isEditingComplaintSuccess: false, //TODO: recheck this later
          complaintPlacesRelativeToMainRegion: const [],
          selectedOrganOrPartSymptom: null,
          mainRegionComplainsLoadingState: OptionsLoadingState.loading,
          complaintPlacesRelativeToMainRegionLoadingState:
              OptionsLoadingState.loading,
          bodySyptomsResults: const [],
          searchResultState: SearchResultState.initial,
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
        isEditingComplaint,
        isEditingComplaintSuccess,
        complaintPlacesRelativeToMainRegion,
        selectedOrganOrPartSymptom,
        mainRegionComplainsLoadingState,
        complaintPlacesRelativeToMainRegionLoadingState,
        bodySyptomsResults,
        searchResultState,
      ];
}

enum SearchResultState {
  initial,
  loading,
  loaded,
  error,
  empty,
}
