part of 'chronic_disease_view_cubit.dart';

class ChronicDiseaseViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<ChronicDiseaseModel> userChronicDisease;
  final PostChronicDiseaseModel? selectedChronicDiseaseDetails;
  final List<int> yearsFilter;
  final List<String> doctorNameFilter;
  final List<String> specificationsFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const ChronicDiseaseViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.doctorNameFilter = const ['الكل'],
    this.specificationsFilter = const ['الكل'],
    this.userChronicDisease = const [],
    this.selectedChronicDiseaseDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  factory ChronicDiseaseViewState.initial() {
    return ChronicDiseaseViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      doctorNameFilter: const ['الكل'],
      specificationsFilter: const ['الكل'],
      userChronicDisease: const [],
      selectedChronicDiseaseDetails: null,
      isDeleteRequest: false,
      isLoadingMore: false,
    );
  }

  ChronicDiseaseViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? doctorNameFilter,
    List<String>? specificationsFilter,
    List<ChronicDiseaseModel>? userChronicDisease,
    PostChronicDiseaseModel? selectedChronicDiseaseDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
  }) {
    return ChronicDiseaseViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      doctorNameFilter: doctorNameFilter ?? this.doctorNameFilter,
      specificationsFilter: specificationsFilter ?? this.specificationsFilter,
      userChronicDisease: userChronicDisease ?? this.userChronicDisease,
      selectedChronicDiseaseDetails:
          selectedChronicDiseaseDetails ?? this.selectedChronicDiseaseDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        yearsFilter,
        doctorNameFilter,
        specificationsFilter,
        userChronicDisease,
        selectedChronicDiseaseDetails,
        isDeleteRequest,
        isLoadingMore
      ];
}
