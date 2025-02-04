part of 'sign_up_cubit.dart';

enum RequestStatus { initial, loading, success, failure }

@immutable
class SignUpState extends Equatable {
  final RequestStatus signupStatus;
  final String? errorMessage;

  const SignUpState({
    this.signupStatus = RequestStatus.initial,
    this.errorMessage,
  }) : super();

  const SignUpState.intialState()
      : this(
          signupStatus: RequestStatus.initial,
        );

  SignUpState copyWith({
    RequestStatus? signupStatus,
    String? errorMessage,
  }) {
    return SignUpState(
      signupStatus: signupStatus ?? this.signupStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        signupStatus,
        errorMessage,
      ];
}
