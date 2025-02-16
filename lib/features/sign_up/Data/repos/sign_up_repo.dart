import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/features/sign_up/Data/models/sign_up_request_body_model.dart';
import 'package:we_care/features/sign_up/Data/models/sign_up_response_model.dart';

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
