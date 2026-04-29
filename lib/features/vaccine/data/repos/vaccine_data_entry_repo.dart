import 'package:we_care/features/vaccine/data/models/vaccine_details_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_request_body_model.dart';
import 'package:we_care/features/vaccine/vaccine_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class VaccineDataEntryRepo {
  final VaccineApiServices _vaccineApiServices;

  VaccineDataEntryRepo({required VaccineApiServices vaccineApiServices})
      : _vaccineApiServices = vaccineApiServices;

  Future<ApiResult<List<String>>> getBirthGenerations({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.getBirthGenerations(
        language,
        userType,
      );
      final data = (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getTargetGroupsByBirthGeneration({
    required String birthCohort,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.getTargetGroupsByBirthGeneration(
        birthCohort,
        language,
        userType,
      );
      final data = (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getVaccineNamesByTargetGroup({
    required String targetGroup,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.getVaccineNamesByTargetGroup(
        targetGroup,
        language,
        userType,
      );
      final data = (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<VaccineDetailsModel>> getVaccineDetailsByName({
    required String vaccineName,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.getVaccineDetailsByName(
        vaccineName,
        language,
        userType,
      );
      return ApiResult.success(
        VaccineDetailsModel.fromJson(response['data'] as Map<String, dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getVaccineCategories({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.getVaccineCategories(
        language,
        userType,
      );
      final categories = (response['data'] as List)
          .map<String>(
            (e) => e.toString(),
          )
          .toList();
      return ApiResult.success(categories);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<VaccineModel>>> getVaccineResultsByCategoryName({
    required String vaccineCategory,
    required String language,
    required String userType,
  }) async {
    try {
      final response =
          await _vaccineApiServices.getVaccineResultsByCategoryName(
        vaccineCategory,
        language,
        userType,
      );
      final vaccines = response["data"][0]["vaccines"];
      final vaccinesResponse = (vaccines as List)
          .map<VaccineModel>((e) => VaccineModel.fromJson(e))
          .toList();

      return ApiResult.success(vaccinesResponse);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postVaccineDataEntry({
    required VaccineModuleRequestBody requestBody,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.postVaccineDataEntry(
        requestBody,
        language,
        userType,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editVaccineData({
    required VaccineModuleRequestBody requestBody,
    required String language,
    required String userType,
    required String vaccineId,
  }) async {
    try {
      final response = await _vaccineApiServices.updateVaccineDataEntry(
        requestBody,
        language,
        userType,
        vaccineId,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
