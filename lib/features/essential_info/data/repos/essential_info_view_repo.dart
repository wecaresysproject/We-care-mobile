import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/essential_info/data/models/get_user_essential_info_response_model.dart';
import 'package:we_care/features/essential_info/essential_info_services.dart';

class EssentialInfoViewRepo {
  final EssentialInfoServices essentialInfoServices;

  EssentialInfoViewRepo({required this.essentialInfoServices});

  Future<ApiResult<GetUserEssentialInfoResponseModel>> getUserEssentialInfo({
    required String language,
    required String userType,
  }) async {
    try {
      final response =
          await essentialInfoServices.getEssentialInfo(language, userType);

      return ApiResult.success(
        GetUserEssentialInfoResponseModel.fromJson(response),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteEssentialInfo({
    required String language,
    required String userType,
    required String docId,
  }) async {
    try {
      final response = await essentialInfoServices.deleteEssentialInfo(
        language,
        userType,
        docId,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
