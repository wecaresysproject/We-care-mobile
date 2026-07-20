part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  final RequestStatus changePasswordStatus;
  final String? message;

  const ChangePasswordState({
    this.changePasswordStatus = RequestStatus.initial,
    this.message,
  }) : super();

  const ChangePasswordState.intialState()
      : this(
          changePasswordStatus: RequestStatus.initial,
        );

  ChangePasswordState copyWith({
    RequestStatus? changePasswordStatus,
    String? message,
  }) {
    return ChangePasswordState(
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        changePasswordStatus,
        message,
      ];
}
