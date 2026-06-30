import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/features/otp/data/models/resend_otp_request_body.dart';
import 'package:we_care/features/otp/data/models/verify_otp_request_body_model.dart';
import 'package:we_care/features/otp/data/repo/otp_repository.dart';

part './otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpRepository otpRepository;
  final otpTextEditingController = TextEditingController();
  OtpCubit(this.otpRepository) : super(OtpState.initial());

  Future<void> verifyOtp(String phoneNumber) async {
    emit(state.copyWith(otpStatus: RequestStatus.loading));

    final response = await otpRepository.verifyOtp(VerifyOtpRequestBodyModel(
      otp: otpTextEditingController.text,
      phoneNumber: phoneNumber,
      language: AppStrings.arabicLang,
    ));

    response.when(success: (response) async {
      await CacheHelper.setSecuredString(
          AuthApiConstants.userTokenKey, response.data.token);
      emit(state.copyWith(
        message: response.message,
        otpStatus: RequestStatus.success,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        message: error.errors.first,
        otpStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> resendOtp(String phoneNumber) async {
    emit(state.copyWith(otpStatus: RequestStatus.loading));

    final response = await otpRepository.resendOtp(
      ResendOtpRequestBody(
        phoneNumber: phoneNumber,
        language: AppStrings.arabicLang,
      ),
    );

    response.when(success: (response) {
      emit(state.copyWith(
        message: response.message,
        otpStatus: RequestStatus.success,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        message: error.errors.first,
        otpStatus: RequestStatus.failure,
      ));
    });
  }
}
