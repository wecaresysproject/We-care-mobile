import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/risk_behaviors_service.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

class RiskBehaviorDataEntryRepo {
  final RiskBehaviorsServices _riskBehaviorsServices;

  RiskBehaviorDataEntryRepo(this._riskBehaviorsServices);

  Future<ApiResult<List<String>>> getSections() async {
    try {
      final response = await _riskBehaviorsServices.getSections();
      final sections =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(sections);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getTypes(String section) async {
    try {
      final response = await _riskBehaviorsServices.getTypes(section);
      final types = (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(types);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getOptions(
      String section, String type) async {
    try {
      final response = await _riskBehaviorsServices.getOptions(section, type);
      final options =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(options);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitRiskyBehaviors(
      RiskyBehaviorDetailsModel body) async {
    try {
      final response = await _riskBehaviorsServices.submitRiskyBehaviors(body);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
