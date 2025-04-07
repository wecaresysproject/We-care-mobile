import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/surgeries/data/models/surgery_request_body_model.dart';
import 'package:we_care/features/surgeries/surgeries_services.dart';

class SurgeriesDataEntryRepo {
  final SurgeriesService _surgeriesService;

  SurgeriesDataEntryRepo({required SurgeriesService surgeriesService})
      : _surgeriesService = surgeriesService;

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _surgeriesService.getCountries(language);
      final countries = (response['data'] as List)
          .map<CountryModel>((e) => CountryModel.fromJson(e))
          .toList();
      return ApiResult.success(countries);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadReportResponseModel>> uploadReportImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _surgeriesService.uploadReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllSurgeriesRegions({
    required String language,
  }) async {
    try {
      final response = await _surgeriesService.getAllSurgeriesRegions(
        language,
      );
      final partRegions =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(partRegions);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllSubSurgeriesRegions({
    required String language,
    required String region,
  }) async {
    try {
      final response = await _surgeriesService.getAllSubSurgeriesRegions(
        region,
        language,
      );
      final partSubRegions =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(partSubRegions);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getSurgeryNamesBasedOnRegion({
    required String language,
    required String region,
    required String subRegion,
  }) async {
    try {
      final response = await _surgeriesService.getSurgeryNameBasedOnRegion(
        region,
        subRegion,
        language,
      );
      final data = (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllTechUsed({
    required String language,
    required String region,
    required String subRegion,
    required String surgeryName,
  }) async {
    try {
      final response = await _surgeriesService.getAllTechUsed(
        region,
        subRegion,
        surgeryName,
        language,
      );
      final data = (response['data'] as List).map((e) => e as String).toList();

      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getSurgeryStatus({
    required String language,
  }) async {
    try {
      final response = await _surgeriesService.getSurgeryStatus(
        language,
      );
      final data = (response['data'] as List).map((e) => e as String).toList();

      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> getSurgeryPurpose({
    required String language,
    required String region,
    required String subRegion,
    required String surgeryName,
    required String techUsed,
  }) async {
    try {
      final response = await _surgeriesService.getSurgeryPurpose(
        region,
        subRegion,
        surgeryName,
        techUsed,
        language,
      );
      final data = (response['data'][0] as String);

      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postModuleData({
    required String language,
    required SurgeryRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _surgeriesService.postSurgeryData(
        language,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> updateSurgeryDocumentById({
    required String id,
    required String langauge,
    required SurgeryRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _surgeriesService.updateSurgeryDocumentById(
        id,
        langauge,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
