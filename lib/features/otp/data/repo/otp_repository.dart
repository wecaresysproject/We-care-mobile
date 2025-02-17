import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/auth_service.dart';
import '../models/verify_otp_request_body.dart';
import '../models/verify_otp_response_model.dart';

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
