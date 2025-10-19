import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_services.dart';

class PhysicalActivatyDataEntryRepo {
  final PhysicalActivityServices _physicalActivityServices;

  PhysicalActivatyDataEntryRepo(this._physicalActivityServices);

  Future<ApiResult<String>> postPersonalUserInfoData({
    required PostPersonalUserInfoData requestBody,
    required String lanugage,
  }) async {
    try {
      final response = await _physicalActivityServices.postPersonalUserInfoData(
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
      final response = await _physicalActivityServices.getAllChronicDiseases(
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
      final response = await _physicalActivityServices.getPlanActivationStatus(
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
      final response = await _physicalActivityServices.postDailyDietPlan(
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
      final response = await _physicalActivityServices.getAllCreatedPlans(
        lanugage,
        planActivationStatus,
        planType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<(bool isAnyActivatedPlans, int currentActivatedPlanIndex)>>
      getAnyActivePlanStatus() async {
    try {
      final response = await _physicalActivityServices.getAnyActivePlanStatus();

      return ApiResult.success(
        (
          response["isActivatedPlans"],
          response["currentActivatedPlan"],
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteDayDietPlan({
    required String date,
  }) async {
    try {
      final response = await _physicalActivityServices.deleteDayDietPlan(
        date,
      );

      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
