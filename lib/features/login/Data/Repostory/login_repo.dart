import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/auth_service.dart';
import '../models/login_request_body_model.dart';
import '../models/login_response_model.dart';

class LoginRepo {
  final AuthApiServices _authApiServices;

  LoginRepo(AuthApiServices authApiServices)
      : _authApiServices = authApiServices;

  Future<ApiResult<LoginResponseModel>> login(
      LoginRequestBodyModel loginRequestBody) async {
    try {
      final response = await _authApiServices.login(loginRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
