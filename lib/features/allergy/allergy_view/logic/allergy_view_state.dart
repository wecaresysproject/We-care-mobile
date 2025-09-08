part of 'allergy_view_cubit.dart';

class AllergyViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<AllergyDiseaseModel> userAllergies;
  final AllergyDetailsData? selectedAllergyDetails;
  final List<int> yearsFilter;
  final List<String> surgeryNameFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const AllergyViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.surgeryNameFilter = const ['الكل'],
    this.userAllergies = const [],
    this.selectedAllergyDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  factory AllergyViewState.initial() {
    return AllergyViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      surgeryNameFilter: const ['الكل'],
      userAllergies: const [],
      selectedAllergyDetails: null,
      isDeleteRequest: false,
      isLoadingMore: false,
    );
  }

  AllergyViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? surgeryNameFilter,
    List<AllergyDiseaseModel>? userAllergies,
    AllergyDetailsData? selectedAllergyDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
  }) {
    return AllergyViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      surgeryNameFilter: surgeryNameFilter ?? this.surgeryNameFilter,
      userAllergies: userAllergies ?? this.userAllergies,
      selectedAllergyDetails:
          selectedAllergyDetails ?? this.selectedAllergyDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        yearsFilter,
        surgeryNameFilter,
        userAllergies,
        selectedAllergyDetails,
        isDeleteRequest,
        isLoadingMore,
      ];
}
