part of 'sign_up_cubit.dart';

@immutable
class SignUpState extends Equatable {
  final RequestStatus signupStatus;
  final String? errorMessage;
  final String successMessage;

  const SignUpState({
    required this.signupStatus,
    this.errorMessage,
    this.successMessage = '',
  }) : super();

  const SignUpState.intialState()
      : this(
          signupStatus: RequestStatus.initial,
        );

  SignUpState copyWith({
    RequestStatus? signupStatus,
    String? errorMessage,
    String? successMessage,
  }) {
    return SignUpState(
      signupStatus: signupStatus ?? this.signupStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        signupStatus,
        errorMessage,
        successMessage,
      ];
}
