import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_new_password_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordState.intialState());

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  void emitCreateNewPasswordStates() async {
    try {
      emit(state.copyWith(createNewPasswordStatus: RequestStatus.loading));

      // Simulating API request delay
      await Future.delayed(Duration(seconds: 2));

      // Example condition (Replace with API logic)
      if (passwordController.text.contains("@")) {
        emit(state.copyWith(createNewPasswordStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            createNewPasswordStatus: RequestStatus.failure,
            errorMessage: 'Invalid email'));
      }
    } catch (e) {
      emit(
        state.copyWith(
          createNewPasswordStatus: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
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
}
