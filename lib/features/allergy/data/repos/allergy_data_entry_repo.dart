import 'dart:io';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/allergy/allergy_services.dart';
import 'package:we_care/features/allergy/data/models/post_allergy_module_data_model.dart';

class AllergyDataEntryRepo {
  final AllergyServices _allergyServices;

  AllergyDataEntryRepo({required AllergyServices allergyServices})
      : _allergyServices = allergyServices;

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

  Future<ApiResult<List<String>>> getAllAllergyTypes({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _allergyServices.getAllAllergyTypes(
        language,
        userType,
      );
      final partSubRegions =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(partSubRegions);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getExpectedSideEffects({
    required String language,
    required String userType,
    required String allergyType,
  }) async {
    try {
      final response = await _allergyServices.getExpectedSideEffects(
        language,
        userType,
        allergyType,
      );
      final partSubRegions =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(partSubRegions);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllergyTriggers({
    required String language,
    required String allergyType,
    required String userType,
  }) async {
    try {
      final response = await _allergyServices.getAllergyTriggers(
        language,
        userType,
        allergyType,
      );

      final data = (response['data'] as List).map((e) => e as String).toList();

      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postAllergyModuleData({
    required String language,
    required PostAllergyModuleDataModel requestBody,
    required String userType,
  }) async {
    try {
      final response = await _allergyServices.postAllergyModuleData(
        language,
        requestBody,
        userType,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> updateAllergyDocumentById({
    required String id,
    required String langauge,
    required PostAllergyModuleDataModel requestBody,
  }) async {
    try {
      final response = await _allergyServices.updateAllergyDocumentById(
        id,
        langauge,
        UserTypes.patient.name.firstLetterToUpperCase,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
