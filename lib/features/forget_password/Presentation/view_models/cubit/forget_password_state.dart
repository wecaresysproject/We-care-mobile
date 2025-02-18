import 'package:equatable/equatable.dart';

import '../../../../../core/global/Helpers/app_enums.dart';

class ForgetPasswordState extends Equatable {
  final RequestStatus forgetPasswordStatus;
  final String message;
  final String dialCode;

  const ForgetPasswordState({
    this.message = '',
    this.dialCode = "+20",
    this.forgetPasswordStatus = RequestStatus.initial,
  });

  factory ForgetPasswordState.initial() {
    return ForgetPasswordState(
      message: '',
      forgetPasswordStatus: RequestStatus.initial,
    );
  }

  ForgetPasswordState copyWith({
    String? message,
    RequestStatus? forgetPasswordStatus,
    String? dialCode,
  }) {
    return ForgetPasswordState(
      message: message ?? this.message,
      forgetPasswordStatus: forgetPasswordStatus ?? this.forgetPasswordStatus,
      dialCode: dialCode ?? this.dialCode,
    );
  }

  @override
  List<Object?> get props => [
        message,
        forgetPasswordStatus,
        dialCode,
      ];
}
