part of 'allergy_view_cubit.dart';

class AllergyViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<SurgeryModel> userSurgeries;
  final SurgeryModel? selectedSurgeryDetails;
  final List<int> yearsFilter;
  final List<String> surgeryNameFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const AllergyViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.surgeryNameFilter = const ['الكل'],
    this.userSurgeries = const [],
    this.selectedSurgeryDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  factory AllergyViewState.initial() {
    return AllergyViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      surgeryNameFilter: const ['الكل'],
      userSurgeries: const [],
      selectedSurgeryDetails: null,
      isDeleteRequest: false,
      isLoadingMore: false,
    );
  }

  AllergyViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? surgeryNameFilter,
    List<SurgeryModel>? userSurgeries,
    SurgeryModel? selectedSurgeryDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
  }) {
    return AllergyViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      surgeryNameFilter: surgeryNameFilter ?? this.surgeryNameFilter,
      userSurgeries: userSurgeries ?? this.userSurgeries,
      selectedSurgeryDetails: selectedSurgeryDetails,
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
        userSurgeries,
        selectedSurgeryDetails,
        isDeleteRequest,
        isLoadingMore,
      ];
}
