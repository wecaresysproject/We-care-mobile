import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/features/create_new_password/Data/models/create_new_password_request_body.dart';
import 'package:we_care/features/create_new_password/Data/models/create_new_password_response_model.dart';

class CreateNewPasswordRepo {
  final AuthApiServices _authApiServices;

  CreateNewPasswordRepo(AuthApiServices authApiServices)
      : _authApiServices = authApiServices;

  Future<ApiResult<CreateNewPasswordResponseModel>> createNewPassword(
      CreateNewPasswordRequestBody createNewPasswordRequestBody) async {
    try {
      final response = await _authApiServices.createNewPassword(
        createNewPasswordRequestBody,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
