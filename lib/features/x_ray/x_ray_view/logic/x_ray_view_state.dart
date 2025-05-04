import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';

class XRayViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<RadiologyData> userRadiologyData;
  final RadiologyData? selectedRadiologyDocument;
  final List<int> yearsFilter;
  final List<String> xrayTypeFilter;
  final List<String> bodyPartFilter;
  final bool isDeleteRequest;
  final bool isLoadingMore;

  const XRayViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.userRadiologyData = const [],
    this.selectedRadiologyDocument,
    this.yearsFilter = const [],
    this.xrayTypeFilter = const ['الكل'],
    this.bodyPartFilter = const ['الكل'],
    this.isDeleteRequest = false,
    this.isLoadingMore = false,
  });

  factory XRayViewState.initial() {
    return XRayViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      userRadiologyData: const [],
      selectedRadiologyDocument: null,
      yearsFilter: const [],
      xrayTypeFilter: const ['الكل'],
      bodyPartFilter: const ['الكل'],
      isDeleteRequest: false,
      isLoadingMore: false,
    );
  }

  XRayViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<RadiologyData>? userRadiologyData,
    RadiologyData? selectedRadiologyDocument,
    List<int>? yearsFilter,
    List<String>? xrayTypeFilter,
    List<String>? bodyPartFilter,
    bool? isDeleteRequest,
    bool? isLoadingMore,
  }) {
    return XRayViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      userRadiologyData: userRadiologyData ?? this.userRadiologyData,
      selectedRadiologyDocument:
          selectedRadiologyDocument ?? this.selectedRadiologyDocument,
      yearsFilter: yearsFilter ?? this.yearsFilter,
      xrayTypeFilter: xrayTypeFilter ?? this.xrayTypeFilter,
      bodyPartFilter: bodyPartFilter ?? this.bodyPartFilter,
      isDeleteRequest: isDeleteRequest ?? this.isDeleteRequest,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        userRadiologyData,
        selectedRadiologyDocument,
        yearsFilter,
        xrayTypeFilter,
        bodyPartFilter,
        isDeleteRequest,
        isLoadingMore,
      ];
}
