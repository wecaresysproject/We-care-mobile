part of 'login_cubit.dart';

enum RequestStatus { initial, loading, success, failure }

@immutable
class LoginState extends Equatable {
  final RequestStatus loginStatus;
  final String? errorMessage;

  const LoginState({
    this.loginStatus = RequestStatus.initial,
    this.errorMessage,
  }) : super();

  const LoginState.intialState()
      : this(
          loginStatus: RequestStatus.initial,
        );

  LoginState copyWith({
    RequestStatus? loginStatus,
    String? errorMessage,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loginStatus,
        errorMessage,
      ];
}
