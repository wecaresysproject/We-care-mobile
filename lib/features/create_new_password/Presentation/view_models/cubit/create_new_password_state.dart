part of 'create_new_password_cubit.dart';

enum RequestStatus { initial, loading, success, failure }

@immutable
class CreateNewPasswordState extends Equatable {
  final RequestStatus createNewPasswordStatus;
  final String? errorMessage;

  const CreateNewPasswordState({
    this.createNewPasswordStatus = RequestStatus.initial,
    this.errorMessage,
  }) : super();

  const CreateNewPasswordState.intialState()
      : this(
          createNewPasswordStatus: RequestStatus.initial,
        );

  CreateNewPasswordState copyWith({
    RequestStatus? createNewPasswordStatus,
    String? errorMessage,
  }) {
    return CreateNewPasswordState(
      createNewPasswordStatus:
          createNewPasswordStatus ?? this.createNewPasswordStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        createNewPasswordStatus,
        errorMessage,
      ];
}
