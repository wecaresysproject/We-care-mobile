import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/global/Helpers/app_enums.dart';
import '../../../core/global/Helpers/extensions.dart';
import '../../../core/global/app_strings.dart';
import '../Data/models/sign_up_request_body_model.dart';
import '../Data/repos/sign_up_repo.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signupRepo) : super(SignUpState.intialState());
  final SignUpRepo _signupRepo;

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
      await _signupRepo.signup(
        signupRequestBody: SignUpRequestBodyModel(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          language:
              AppStrings.arabicLang, //TODO: use the selected one from user
          userType: UserTypes.patient.name.firstLetterToUpperCase(),
          phoneNumber: "+20${phoneController.text}",
          password: passwordController.text,
          confirmPassword:
              passwordConfirmationController.text, //! remove it later
        ),
      );
      emit(
        state.copyWith(
          signupStatus: RequestStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          signupStatus: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
