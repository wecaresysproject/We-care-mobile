import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/essential_info/data/models/get_user_essential_info_response_model.dart';

class EssentialInfoViewState extends Equatable {
  final RequestStatus requestStatus;
  final RequestStatus deleteRequestStatus;
  final String responseMessage;
  final UserEssentialInfoData? userEssentialInfo;
  final double profileCompletionPercentage;

  const EssentialInfoViewState({
    this.requestStatus = RequestStatus.initial,
    this.deleteRequestStatus = RequestStatus.initial,
    this.responseMessage = '',
    this.userEssentialInfo,
    this.profileCompletionPercentage = 0.0,
  });

  factory EssentialInfoViewState.initial() {
    return const EssentialInfoViewState(
      requestStatus: RequestStatus.initial,
      responseMessage: '',
      userEssentialInfo: null,
      deleteRequestStatus: RequestStatus.initial,
      profileCompletionPercentage: 0.0,
    );
  }

  EssentialInfoViewState copyWith({
    RequestStatus? requestStatus,
    String? responseMessage,
    UserEssentialInfoData? userEssentialInfo,
    RequestStatus? deleteRequestStatus,
    double? profileCompletionPercentage,
  }) {
    return EssentialInfoViewState(
      requestStatus: requestStatus ?? this.requestStatus,
      responseMessage: responseMessage ?? this.responseMessage,
      userEssentialInfo: userEssentialInfo ?? this.userEssentialInfo,
      deleteRequestStatus: deleteRequestStatus ?? this.deleteRequestStatus,
      profileCompletionPercentage:
          profileCompletionPercentage ?? this.profileCompletionPercentage,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        responseMessage,
        userEssentialInfo,
        deleteRequestStatus,
        profileCompletionPercentage,
      ];
}
