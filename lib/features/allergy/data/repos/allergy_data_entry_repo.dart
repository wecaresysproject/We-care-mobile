import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/allergy/allergy_services.dart';
import 'package:we_care/features/allergy/data/models/post_allergy_module_data_model.dart';
import 'package:we_care/features/surgeries/data/models/surgery_request_body_model.dart';

class AllergyDataEntryRepo {
  final AllergyServices _allergyServices;

  AllergyDataEntryRepo({required AllergyServices allergyServices})
      : _allergyServices = allergyServices;

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _allergyServices.getCountries(language);
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
      final response = await _allergyServices.uploadReportImage(
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
      final response = await _allergyServices.getAllSurgeriesRegions(
        language,
      );
      final partRegions =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(partRegions);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllAllergyTypes({
    required String language,
  }) async {
    try {
      final response = await _allergyServices.getAllAllergyTypes(
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
      final response = await _allergyServices.getSurgeryNameBasedOnRegion(
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
      final response = await _allergyServices.getAllTechUsed(
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

  Future<ApiResult<List<String>>> getAllergyTriggers({
    required String language,
    required String allergyType,
  }) async {
    try {
      final response = await _allergyServices.getAllergyTriggers(
        language,
        allergyType,
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
      final response = await _allergyServices.getSurgeryPurpose(
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

  Future<ApiResult<String>> postAllergyModuleData({
    required String language,
    required PostAllergyModuleDataModel requestBody,
  }) async {
    try {
      final response = await _allergyServices.postAllergyModuleData(
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
      final response = await _allergyServices.updateSurgeryDocumentById(
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
