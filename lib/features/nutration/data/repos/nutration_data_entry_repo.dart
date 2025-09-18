import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/nutration/nutration_services.dart';

class NutrationDataEntryRepo {
  final NutrationServices _nutrationServices;

  NutrationDataEntryRepo(this._nutrationServices);

  Future<ApiResult<String>> postPersonalNutritionData({
    required PostPersonalNutritionData requestBody,
    required String lanugage,
  }) async {
    try {
      final response = await _nutrationServices.postPersonalNutritionData(
        requestBody,
        lanugage,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllChronicDiseases({
    required String language,
  }) async {
    try {
      final response = await _nutrationServices.getAllChronicDiseases(
        language,
      );
      final chronicDiseases =
          response['data'].map<String>((e) => e as String).toList();
      return ApiResult.success(chronicDiseases);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> getPlanActivationStatus({
    required String language,
    required String planType,
  }) async {
    try {
      final response = await _nutrationServices.getPlanActivationStatus(
        language,
        planType,
      );
      final planStatus = response['status'] as bool;
      return ApiResult.success(planStatus);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
