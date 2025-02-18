import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/global/Helpers/app_enums.dart';
import '../../../../../core/global/app_strings.dart';
import '../../../Data/models/create_new_password_request_body.dart';
import '../../../Data/repo/create_new_password_repo.dart';

part 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  final CreateNewPasswordRepo _createNewPasswordRepo;
  CreateNewPasswordCubit(this._createNewPasswordRepo)
      : super(CreateNewPasswordState.intialState());

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  void emitCreateNewPasswordStates(final String phoneNumber) async {
    emit(state.copyWith(createNewPasswordStatus: RequestStatus.loading));

    final response = await _createNewPasswordRepo.createNewPassword(
      CreateNewPasswordRequestBody(
        phoneNumber: phoneNumber,
        newPassword: passwordController.text,
        confirmPassword: passwordConfirmationController.text,
        language: AppStrings.arabicLang,
      ),
    );

    response.when(
      success: (createNewPasswordResponseModel) {
        emit(state.copyWith(
          createNewPasswordStatus: RequestStatus.success,
          message: createNewPasswordResponseModel.message,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          createNewPasswordStatus: RequestStatus.failure,
          message: error.errors.first,
        ));
      },
    );
  }
  // void emitSignupStates() async {
  //   emit(const SignupState.signupLoading());
  //   final response = await _signupRepo.signup(
  //     SignupRequestBody(
  //       name: nameController.text,
  //       email: emailController.text,
  //       phone: phoneController.text,
  //       password: passwordController.text,
  //       passwordConfirmation: passwordConfirmationController.text,
  //       gender: 0,
  //     ),
  //   );
  //   response.when(success: (signupResponse) {
  //     emit(SignupState.signupSuccess(signupResponse));
  //   }, failure: (error) {
  //     emit(SignupState.signupError(error: error.apiErrorModel.message ?? ''));
  //   });
  // }

  @override
  Future<void> close() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
