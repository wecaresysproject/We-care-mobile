part of 'sign_up_cubit.dart';

@immutable
class SignUpState extends Equatable {
  final RequestStatus signupStatus;
  final String? errorMessage;
  final String successMessage;
  final RequestStatus termsAndConditionsStatus;
  final List<TermsAndConditionsResponseModel>? termsAndConditions;
  final String termsErrorMessage;
  const SignUpState({
    required this.signupStatus,
    this.errorMessage,
    this.successMessage = '',
    this.termsAndConditionsStatus = RequestStatus.initial,
    this.termsAndConditions = const [],
    this.termsErrorMessage = '',
  }) : super();

  const SignUpState.intialState()
      : this(
          signupStatus: RequestStatus.initial,
          termsAndConditionsStatus: RequestStatus.initial,
          termsAndConditions: const [],
        );

  SignUpState copyWith({
    RequestStatus? signupStatus,
    String? errorMessage,
    String? successMessage,
    RequestStatus? termsAndConditionsStatus,
    List<TermsAndConditionsResponseModel>? termsAndConditions,
    String? termsErrorMessage,
  }) {
    return SignUpState(
      signupStatus: signupStatus ?? this.signupStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      termsAndConditionsStatus:
          termsAndConditionsStatus ?? this.termsAndConditionsStatus,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      termsErrorMessage: termsErrorMessage ?? this.termsErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        signupStatus,
        errorMessage,
        successMessage,
        termsAndConditionsStatus,
        termsAndConditions,
        termsErrorMessage,
      ];
}
