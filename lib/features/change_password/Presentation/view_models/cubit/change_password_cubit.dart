import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/change_password/data/models/change_password_request_body_model.dart';
import 'package:we_care/features/change_password/data/repos/change_password_repo.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo _changePasswordRepo;

  ChangePasswordCubit(this._changePasswordRepo)
      : super(ChangePasswordState.intialState());

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> changePassword() async {
    emit(state.copyWith(changePasswordStatus: RequestStatus.loading));

    final response = await _changePasswordRepo.changePassword(
      ChangePasswordRequestBodyModel(
        oldPassword: currentPasswordController.text,
        newPassword: passwordController.text,
        confirmPassword: passwordConfirmationController.text,
      ),
    );

    response.when(
      success: (changePasswordResponseModel) {
        emit(state.copyWith(
          changePasswordStatus: RequestStatus.success,
          message: changePasswordResponseModel.message,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          changePasswordStatus: RequestStatus.failure,
          message: error.errors.first,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
