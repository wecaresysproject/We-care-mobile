import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';
import 'package:we_care/features/supplements/supplements_services.dart';

class SupplementsDataEntryRepo {
  final SupplementsServices services;

  SupplementsDataEntryRepo({required this.services});

  Future<ApiResult<List<String>>> retrieveAvailableVitamins({
    required String language,
  }) async {
    try {
      final response = await services.retrieveAvailableVitamins(language);
      final data = (response['data'] as List).map<String>((e) => e).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<(bool isAnyActivatedPlans, int currentActivatedPlanIndex)>>
      getAnyActivePlanStatus() async {
    try {
      final response = await services.getAnyActivePlanStatus();

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

  Future<ApiResult<bool>> getPlanActivationStatus({
    required String language,
    required String planType,
  }) async {
    try {
      final response = await services.getPlanActivationStatus(
        language,
        planType,
      );
      final planStatus = response['status'] as bool;
      return ApiResult.success(planStatus);
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
      final response = await services.getAllCreatedPlans(
        lanugage,
        planActivationStatus,
        planType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitSelectedSupplements({
    required List<SupplementEntry> supplements,
  }) async {
    try {
      final response = await services.submitSelectedSupplements(supplements);
      return ApiResult.success(response['message'] as String);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
