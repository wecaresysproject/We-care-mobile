part of 'login_cubit.dart';

@immutable
class LoginState extends Equatable {
  final RequestStatus loginStatus;
  final String message;
  final String dialCode;

  const LoginState({
    required this.loginStatus,
    this.message = '',
    this.dialCode = '+20',
  }) : super();

  const LoginState.intialState()
      : this(
          loginStatus: RequestStatus.initial,
        );

  LoginState copyWith({
    RequestStatus? loginStatus,
    String? message,
    String? dialCode,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
      dialCode: dialCode ?? this.dialCode,
    );
  }

  @override
  List<Object?> get props => [
        loginStatus,
        message,
        dialCode,
      ];
}
