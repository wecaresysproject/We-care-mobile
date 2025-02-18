import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/global/Helpers/app_enums.dart';
import '../../../../../core/global/app_strings.dart';
import '../../../Data/Repostory/forget_password_repo.dart';
import '../../../Data/models/forget_password_request_body_model.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._forgetPasswordRepo)
      : super(ForgetPasswordState.initial());
  final ForgetPasswordRepo _forgetPasswordRepo;
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> emitForgetPasswordState() async {
    emit(state.copyWith(forgetPasswordStatus: RequestStatus.loading));

    final response = await _forgetPasswordRepo.forgetPassword(
      ForgetPasswordRequestBodyModel(
        phoneNumber: "+2${phoneController.text}",
        language: AppStrings.arabicLang,
      ),
    );

    response.when(success: (response) async {
      emit(state.copyWith(
        message: response.message,
        forgetPasswordStatus: RequestStatus.success,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        message: error.errors.first,
        forgetPasswordStatus: RequestStatus.failure,
      ));
    });
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
  Future<void> close() {
    phoneController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
