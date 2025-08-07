import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';

class PrescriptionViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<PrescriptionModel> userPrescriptions;
  final PrescriptionModel? selectedPrescriptionDetails;
  final List<int> yearsFilter;
  final List<String> doctorNameFilter;
  final List<String> specificationsFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const PrescriptionViewState({
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

  factory PrescriptionViewState.initial() {
    return PrescriptionViewState(
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

  PrescriptionViewState copyWith({
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
    return PrescriptionViewState(
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
