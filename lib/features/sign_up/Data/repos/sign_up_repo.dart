import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/auth_service.dart';
import '../models/sign_up_request_body_model.dart';
import '../models/sign_up_response_model.dart';

class SignUpRepo {
  final AuthApiServices _authApiServices;

  SignUpRepo(AuthApiServices authApiServices)
      : _authApiServices = authApiServices;

  Future<ApiResult<SignUpResponseModel>> signup(
      {required SignUpRequestBodyModel signupRequestBody}) async {
    try {
      final response = await _authApiServices.signup(signupRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
