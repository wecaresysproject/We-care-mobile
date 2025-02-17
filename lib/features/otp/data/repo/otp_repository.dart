// ignore_for_file: prefer_relative_imports

import 'package:we_care/features/otp/Data/models/verify_otp_request_body_model.dart';
import 'package:we_care/features/otp/Data/models/verify_otp_response_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/auth_service.dart';

class OtpRepository {
  final AuthApiServices _authApiServices;

  OtpRepository(AuthApiServices authApiServices)
      : _authApiServices = authApiServices;

  Future<ApiResult<VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestBodyModel requestBody,
  ) async {
    try {
      final response = await _authApiServices.verifyOtp(requestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
