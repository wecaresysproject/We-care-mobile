part of 'chronic_disease_view_cubit.dart';

class ChronicDiseaseViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<PrescriptionModel> userPrescriptions;
  final PrescriptionModel? selectedPrescriptionDetails;
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
    this.userPrescriptions = const [],
    this.selectedPrescriptionDetails,
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
      userPrescriptions: const [],
      selectedPrescriptionDetails: null,
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
    List<PrescriptionModel>? userPrescriptions,
    PrescriptionModel? selectedPrescriptionDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
  }) {
    return ChronicDiseaseViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      doctorNameFilter: doctorNameFilter ?? this.doctorNameFilter,
      specificationsFilter: specificationsFilter ?? this.specificationsFilter,
      userPrescriptions: userPrescriptions ?? this.userPrescriptions,
      selectedPrescriptionDetails:
          selectedPrescriptionDetails ?? this.selectedPrescriptionDetails,
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
        userPrescriptions,
        selectedPrescriptionDetails,
        isDeleteRequest,
        isLoadingMore
      ];
}
