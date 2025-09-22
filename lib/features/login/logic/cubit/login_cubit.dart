import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/login/Data/models/login_response_model.dart';

import '../../../../core/Database/cach_helper.dart';
import '../../../../core/global/Helpers/app_enums.dart';
import '../../../../core/global/app_strings.dart';
import '../../../../core/networking/auth_api_constants.dart';
import '../../Data/Repostory/login_repo.dart';
import '../../Data/models/login_request_body_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepo) : super(LoginState.intialState());
  final LoginRepo _loginRepo;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> emitLoginStates() async {
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    final response = await _loginRepo.login(
      LoginRequestBodyModel(
        password: passwordController.text,
        phoneNumber: phoneController
            .text, //! handle app regex to be started from 1022647417
        language: AppStrings.arabicLang, //TOD to change this later
      ),
    );

    response.when(success: (response) async {
      await saveUserToken(response);
      emit(
        state.copyWith(
          message: response.message,
          loginStatus: RequestStatus.success,
        ),
      );
    }, failure: (error) {
      emit(state.copyWith(
        message: error.errors.first,
        loginStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> saveUserToken(LoginResponseModel response) async {
    await CacheHelper.setSecuredString(
        AuthApiConstants.userTokenKey, response.userData.token);
    DioServices.setTokenIntoHeaderAfterLogin(response.userData.token);
  }

  void onDialCodeChanged(CountryCode country) {
    // use emit to the state in hint text of textfield later
    emit(
      state.copyWith(
        dialCode: country.dialCode,
      ),
    );
    log("xxx: new dialCode ${country.dialCode}");
  }

  @override
  Future<void> close() async {
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
