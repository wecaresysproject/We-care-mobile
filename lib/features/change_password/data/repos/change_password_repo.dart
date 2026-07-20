import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/features/change_password/data/models/change_password_request_body_model.dart';
import 'package:we_care/features/change_password/data/models/change_password_response_model.dart';

class ChangePasswordRepo {
  final AuthApiServices _authApiServices;

  ChangePasswordRepo(AuthApiServices authApiServices)
      : _authApiServices = authApiServices;

  Future<ApiResult<ChangePasswordResponseModel>> changePassword(
      ChangePasswordRequestBodyModel changePasswordRequestBodyModel) async {
    try {
      final response = await _authApiServices.changePassword(
        changePasswordRequestBodyModel,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
