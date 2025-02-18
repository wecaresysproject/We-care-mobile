import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/auth_service.dart';
import '../models/forget_password_request_body_model.dart';
import '../models/forget_password_response_model.dart';

class ForgetPasswordRepo {
  final AuthApiServices _authApiServices;

  ForgetPasswordRepo(AuthApiServices authApiServices)
      : _authApiServices = authApiServices;

  Future<ApiResult<ForgetPasswordResponseModel>> forgetPassword(
      ForgetPasswordRequestBodyModel forgetPasswordRequestBody) async {
    try {
      final response =
          await _authApiServices.forgetPassword(forgetPasswordRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
