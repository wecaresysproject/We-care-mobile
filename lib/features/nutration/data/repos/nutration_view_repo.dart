import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/nutration/data/models/food_alternative_category_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_document_model.dart';
import 'package:we_care/features/nutration/nutration_services.dart';

class NutrationViewRepo {
  final NutrationServices nutrationServices;

  NutrationViewRepo({required this.nutrationServices});

  Future<ApiResult<List<int>>> getAvailableYearsForWeeklyPlan({
    required String language,
  }) async {
    try {
      final response = await nutrationServices.getAvailableYearsForWeeklyPlan(
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
      final response = await nutrationServices.getAvailableYearsForMonthlyPlan(
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
          await nutrationServices.getAvailableDateRangesForWeeklyPlan(
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
          await nutrationServices.getAvailableDateRangesForMonthlyPlan(
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
      final response = await nutrationServices.getNutrationDocuments(
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
      final response = await nutrationServices.getFilterdNutritionDocuments(
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

  Future<ApiResult<List<AlternativeFoodCategoryModel>>> getFoodAlternatives({
    required String language,
    required String elementName,
  }) async {
    try {
      final response = await nutrationServices.getFoodAlternatives(
        language,
        elementName,
      );
      final documents = (response['data'] as List)
          .map<AlternativeFoodCategoryModel>(
              (e) => AlternativeFoodCategoryModel.fromJson(e))
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
  //     final response = await nutrationServices.getAllFilters(
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
  //     final response = await nutrationServices.getFilteredBiometrics(
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
  //     final response = await nutrationServices.getCurrentBiometricData(
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
