import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/nutration/nutration_services.dart';

class NutrationDataEntryRepo {
  final NutrationServices _nutrationServices;

  NutrationDataEntryRepo(this._nutrationServices);

  Future<ApiResult<String>> postPersonalUserInfoData({
    required PostPersonalUserInfoData requestBody,
    required String lanugage,
  }) async {
    try {
      final response = await _nutrationServices.postPersonalUserInfoData(
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

  Future<ApiResult<String>> postDailyDietPlan({
    required NutrationFactsModel requestBody,
    required String lanugage,
    required String date,
  }) async {
    try {
      final response = await _nutrationServices.postDailyDietPlan(
        requestBody,
        lanugage,
        date,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetAllCreatedPlansModel>> getAllCreatedPlans({
    required String lanugage,
    required bool planActivationStatus,
    required String planType,
  }) async {
    try {
      final response = await _nutrationServices.getAllCreatedPlans(
        lanugage,
        planActivationStatus,
        planType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
