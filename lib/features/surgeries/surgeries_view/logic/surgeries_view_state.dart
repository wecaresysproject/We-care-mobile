import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';

class SurgeriesViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<SurgeryModel> userSurgeries;
  final SurgeryModel? selectedSurgeryDetails;
  final List<int> yearsFilter;
  final List<String> surgeryNameFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const SurgeriesViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.yearsFilter = const [],
    this.surgeryNameFilter = const ['الكل'],
    this.userSurgeries = const [],
    this.selectedSurgeryDetails,
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
    this.moduleGuidanceData,
  });

  factory SurgeriesViewState.initial() {
    return SurgeriesViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      yearsFilter: const [],
      surgeryNameFilter: const ['الكل'],
      userSurgeries: const [],
      selectedSurgeryDetails: null,
      isDeleteRequest: false,
      isLoadingMore: false,
      moduleGuidanceData: null,
    );
  }

  SurgeriesViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<int>? yearsFilter,
    List<String>? surgeryNameFilter,
    List<SurgeryModel>? userSurgeries,
    SurgeryModel? selectedSurgeryDetails,
    bool? isDeleteRequest,
    bool? isLoadingMore,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return SurgeriesViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      surgeryNameFilter: surgeryNameFilter ?? this.surgeryNameFilter,
      userSurgeries: userSurgeries ?? this.userSurgeries,
      selectedSurgeryDetails: selectedSurgeryDetails,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
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
        moduleGuidanceData,
      ];
}
