import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/essential_info/data/models/get_user_essential_info_response_model.dart';

class EssentialInfoViewState extends Equatable {
  final RequestStatus requestStatus;
  final RequestStatus deleteRequestStatus ;
  final String responseMessage;
  final UserEssentialInfoData? userEssentialInfo;

  const EssentialInfoViewState({
    this.requestStatus = RequestStatus.initial,
    this.deleteRequestStatus = RequestStatus.initial,
    this.responseMessage = '',
    this.userEssentialInfo,
  });

  factory EssentialInfoViewState.initial() {
    return const EssentialInfoViewState(
      requestStatus: RequestStatus.initial,
      responseMessage: '',
      userEssentialInfo: null,
      deleteRequestStatus: RequestStatus.initial,
    );
  }

  EssentialInfoViewState copyWith({
    RequestStatus? requestStatus,
    String? responseMessage,
    UserEssentialInfoData? userEssentialInfo,
    RequestStatus? deleteRequestStatus
  }) {
    return EssentialInfoViewState(
      requestStatus: requestStatus ?? this.requestStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      userEssentialInfo: userEssentialInfo ?? this.userEssentialInfo,
      deleteRequestStatus: deleteRequestStatus ?? this.deleteRequestStatus
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        userEssentialInfo,
        deleteRequestStatus,
      ];
}
