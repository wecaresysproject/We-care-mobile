part of 'create_new_password_cubit.dart';

class CreateNewPasswordState extends Equatable {
  final RequestStatus createNewPasswordStatus;
  final String? message;

  const CreateNewPasswordState({
    this.createNewPasswordStatus = RequestStatus.initial,
    this.message,
  }) : super();

  const CreateNewPasswordState.intialState()
      : this(
          createNewPasswordStatus: RequestStatus.initial,
        );

  CreateNewPasswordState copyWith({
    RequestStatus? createNewPasswordStatus,
    String? message,
  }) {
    return CreateNewPasswordState(
      createNewPasswordStatus:
          createNewPasswordStatus ?? this.createNewPasswordStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        createNewPasswordStatus,
        message,
      ];
}
