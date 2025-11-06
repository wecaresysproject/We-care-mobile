import 'dart:developer';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_lens_data_request_body_model.dart';
import 'package:we_care/features/eyes/eyes_services.dart';

class GlassesDataEntryRepo {
  final EyesModuleServices _eyesModuleServices;

  GlassesDataEntryRepo({required EyesModuleServices eyesModuleServices})
      : _eyesModuleServices = eyesModuleServices;

  Future<ApiResult<String>> postGlassesLensDataEntry({
    required String language,
    required String userType,
    required EyeGlassesLensDataRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _eyesModuleServices.postGlassesLensDataEntry(
        language,
        userType,
        requestBody,
      );
      log("xxx: response: $response[message]");
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllLensSurfaces({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _eyesModuleServices.getAllLensSurfaces(
        language,
        userType,
      );
      final lensSurfaces =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(lensSurfaces);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllLensTypes({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _eyesModuleServices.getAllLensTypes(
        language,
        userType,
      );
      final lensTypes =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(lensTypes);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editGlassesDataEntered({
    required EyeGlassesLensDataRequestBodyModel requestBody,
    required String language,
    required String id,
  }) async {
    try {
      final response = await _eyesModuleServices.editGlassesDataEntered(
        requestBody,
        language,
        id,
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
