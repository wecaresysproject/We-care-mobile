import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState.intialState());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> emitSignupStates() async {
    try {
      emit(state.copyWith(signupStatus: RequestStatus.loading));

      // Simulating API request delay
      await Future.delayed(Duration(seconds: 2));

      // Example condition (Replace with API logic)
      if (emailController.text.contains("@")) {
        emit(state.copyWith(signupStatus: RequestStatus.success));
      } else {
        emit(state.copyWith(
            signupStatus: RequestStatus.failure,
            errorMessage: 'Invalid email'));
      }
    } catch (e) {
      emit(
        state.copyWith(
          signupStatus: RequestStatus.failure,
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
