import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';

class XRayViewState extends Equatable {
  final RequestStatus requestStatus;
  final String responseMessage;
  final List<RadiologyData> userRadiologyData;
  final RadiologyData? selectedRadiologyDocument;

  const XRayViewState({
    this.responseMessage = '',
    this.requestStatus = RequestStatus.initial,
    this.userRadiologyData = const [],
    this.selectedRadiologyDocument,
  });

  factory XRayViewState.initial() {
    return XRayViewState(
      responseMessage: '',
      requestStatus: RequestStatus.initial,
      userRadiologyData: const [],
      selectedRadiologyDocument: null,
    );
  }

  XRayViewState copyWith({
    String? responseMessage,
    RequestStatus? requestStatus,
    List<RadiologyData>? userRadiologyData,
    RadiologyData? selectedRadiologyDocument,
  }) {
    return XRayViewState(
      responseMessage: responseMessage ?? this.responseMessage,
      requestStatus: requestStatus ?? this.requestStatus,
      userRadiologyData: userRadiologyData ?? this.userRadiologyData,
      selectedRadiologyDocument:
          selectedRadiologyDocument ?? this.selectedRadiologyDocument,
    );
  }

  @override
  List<Object?> get props => [
        responseMessage,
        requestStatus,
        userRadiologyData,
        selectedRadiologyDocument,
      ];
}
