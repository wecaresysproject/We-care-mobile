import 'package:equatable/equatable.dart';

import '../../../core/global/Helpers/app_enums.dart';

class OtpState extends Equatable {
  final RequestStatus otpStatus;
  final String message;

  const OtpState({
    this.message = '',
    this.otpStatus = RequestStatus.initial,
  });

  factory OtpState.initial() {
    return OtpState(
      message: '',
      otpStatus: RequestStatus.initial,
    );
  }

  OtpState copyWith({
    String? message,
    RequestStatus? otpStatus,
  }) {
    return OtpState(
      message: message ?? this.message,
      otpStatus: otpStatus ?? this.otpStatus,
    );
  }

  @override
  List<Object?> get props => [
        message,
        otpStatus,
      ];
}
