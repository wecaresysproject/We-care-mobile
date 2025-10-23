import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/Biometrics/biometrics_services.dart';
import 'package:we_care/features/Biometrics/data/models/biometric_filters_model.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';
import 'package:we_care/features/Biometrics/data/models/current_biometrics_data.dart';

class BiometricsViewRepo {
  final BiometricsServices _biometricsServices;

  BiometricsViewRepo({required BiometricsServices biometricsServices})
      : _biometricsServices = biometricsServices;

  Future<ApiResult<List<String>>> getAllAvailableBiometrics({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _biometricsServices.getAllAvailableBiometrics(
        language,
        userType,
      );
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
  Future<ApiResult<BiometricFiltersModel>> getAllFilters({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _biometricsServices.getAllFilters(
        language,
        userType,
      );
      return ApiResult.success(BiometricFiltersModel.fromJson(response["data"]));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }  

  Future<ApiResult<List<BiometricsDatasetModel>>> getFilteredBiometrics({
    required String language,
    required String userType,
    int? year,
    int? month,
    int? day,
   required List<String> biometricCategories,
  }) async {
    try {
      final response = await _biometricsServices.getFilteredBiometrics(
        language,
        userType,
        year?.toString(),
        month?.toString(),
        day?.toString(),
        biometricCategories,
      );
      return ApiResult.success(
        (response["biometrics"] as List<dynamic>)
            .map((e) => BiometricsDatasetModel.fromJson(e))
            .toList(),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }  

  Future<ApiResult<CurrentBioMetricsData>> getCurrentBiometricData({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _biometricsServices.getCurrentBiometricData(
        language,
        userType,
      );
      return ApiResult.success(CurrentBioMetricsData.fromJson(response["data"]['measurements']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

    Future<ApiResult<String>> deleteBiometricDataOfSpecifcCategory({
    required String language,
    required String userType,
    required String date,
    required String biometricName,
  }) async {
    try {
      final response = await _biometricsServices.deleteBiometricDataOfSpecifcCategory(
         userType,
         language,
         date,
         biometricName);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editBiometricDataOfSpecifcCategory({
    required dynamic requestBody,
    required String language,
    required String userType,
    required String date,
    required String biometricName,
  }) async {
    try {
      final response = await _biometricsServices.editBiometricDataOfSpecifcCategory(
         requestBody,
         userType,
         language,
         date,
         biometricName);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
