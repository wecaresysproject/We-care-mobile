import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/nutration/data/models/nutration_document_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_services.dart';

class PhysicalActivatyViewRepo {
  final PhysicalActivityServices physicalActivityServices;

  PhysicalActivatyViewRepo({required this.physicalActivityServices});

  Future<ApiResult<List<int>>> getAvailableYearsForWeeklyPlan({
    required String language,
  }) async {
    try {
      final response =
          await physicalActivityServices.getAvailableYearsForWeeklyPlan(
        language,
      );
      final years = (response['data'] as List).map<int>((e) => e).toList();
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<int>>> getAvailableYearsForMonthlyPlan({
    required String language,
  }) async {
    try {
      final response =
          await physicalActivityServices.getAvailableYearsForMonthlyPlan(
        language,
      );
      final years = (response['data'] as List).map<int>((e) => e).toList();

      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAvailableDateRangesForWeeklyPlan({
    required String language,
    required String year,
  }) async {
    try {
      final response =
          await physicalActivityServices.getAvailableDateRangesForWeeklyPlan(
        language,
        year,
      );
      final years = (response['data'] as List).map<String>((e) => e).toList();
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAvailableDateRangesForMonthlyPlan({
    required String language,
    required String year,
  }) async {
    try {
      final response =
          await physicalActivityServices.getAvailableDateRangesForMonthlyPlan(
        language,
        year,
      );
      final years = (response['data'] as List).map<String>((e) => e).toList();

      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<NutrationDocument>>> getNutrationDocuments({
    required String language,
    required String planType,
  }) async {
    try {
      final response = await physicalActivityServices.getNutrationDocuments(
        language,
        planType,
      );
      final documents = (response['data'] as List)
          .map<NutrationDocument>((e) => NutrationDocument.fromJson(e))
          .toList();

      return ApiResult.success(documents);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<NutrationDocument>>> getFilterdNutritionDocuments({
    required String language,
    required String year,
    required String planType,
    required String rangeDate,
  }) async {
    try {
      final response =
          await physicalActivityServices.getFilterdNutritionDocuments(
        language,
        year,
        rangeDate,
        planType,
      );
      final documents = (response['data'] as List)
          .map<NutrationDocument>((e) => NutrationDocument.fromJson(e))
          .toList();

      return ApiResult.success(documents);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<BiometricFiltersModel>> getAllFilters({
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response = await physicalActivityServices.getAllFilters(
  //       language,
  //       userType,
  //     );
  //     return ApiResult.success(
  //         BiometricFiltersModel.fromJson(response["data"]));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<List<BiometricsDatasetModel>>> getFilteredBiometrics({
  //   required String language,
  //   required String userType,
  //   int? year,
  //   int? month,
  //   int? day,
  //   required List<String> biometricCategories,
  // }) async {
  //   try {
  //     final response = await physicalActivityServices.getFilteredBiometrics(
  //       language,
  //       userType,
  //       year?.toString(),
  //       month?.toString(),
  //       day?.toString(),
  //       biometricCategories,
  //     );
  //     return ApiResult.success(
  //       (response["biometrics"] as List<dynamic>)
  //           .map((e) => BiometricsDatasetModel.fromJson(e))
  //           .toList(),
  //     );
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<CurrentBioMetricsData>> getCurrentBiometricData({
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response = await physicalActivityServices.getCurrentBiometricData(
  //       language,
  //       userType,
  //     );
  //     return ApiResult.success(
  //         CurrentBioMetricsData.fromJson(response["data"]['measurements']));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
