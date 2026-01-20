import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_day_model.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_metrics_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_services.dart';

class PhysicalActivatyViewRepo {
  final PhysicalActivityServices physicalActivityServices;

  PhysicalActivatyViewRepo({required this.physicalActivityServices});

  Future<ApiResult<List<int>>> getAvailableYears({
    required String language,
  }) async {
    try {
      final response = await physicalActivityServices.getAvailableYears(
        language,
      );
      final years = (response['data'] as List).map<int>((e) => e).toList();
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAvailableDatesBasedOnYear({
    required String language,
    required String year,
  }) async {
    try {
      final response =
          await physicalActivityServices.getAvailableDatesBasedOnYear(
        language,
        year,
      );
      final years = (response['data'] as List).map<String>((e) => e).toList();
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<PhysicalActivityMetricsResponse>> getPhysicalActivitySlides({
    required String language,
  }) async {
    try {
      final response = await physicalActivityServices.getPhysicalActivitySlides(
        language,
      );

      return ApiResult.success(
        PhysicalActivityMetricsResponse.fromJson(
          response,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<PhysicalActivityMetricsResponse>> getFilterdDocuments({
    required String language,
    required String year,
    required String range,
  }) async {
    try {
      final response = await physicalActivityServices.getFilterdDocuments(
        language,
        year,
        range,
      );

      return ApiResult.success(
        PhysicalActivityMetricsResponse.fromJson(
          response,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<PhysicalActivityDayModel>>> getFollowUpReports() async {
    try {
      final response = await physicalActivityServices.getFollowUpReports();
      final physicalActivityDayModel = (response['data'] as List)
          .map<PhysicalActivityDayModel>(
              (e) => PhysicalActivityDayModel.fromJson(e))
          .toList();
      return ApiResult.success(physicalActivityDayModel);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
