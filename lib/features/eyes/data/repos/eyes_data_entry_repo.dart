import 'dart:io';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/eyes/data/models/eye_data_entry_request_body_model.dart';
import 'package:we_care/features/eyes/data/models/eye_part_syptoms_and_procedures_response_model.dart';
import 'package:we_care/features/eyes/eyes_services.dart';

class EyesDataEntryRepo {
  final EyesModuleServices _eyesService;

  EyesDataEntryRepo({required EyesModuleServices eyesService})
      : _eyesService = eyesService;

  Future<ApiResult<List<String>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _eyesService.getCountries(language);
      final countriesNames = (response['data'] as List)
          .map((e) => CountryModel.fromJson(e).name)
          .toList();
      return ApiResult.success(countriesNames);
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
      final response = await _eyesService.uploadReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadMedicalExaminationImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _eyesService.uploadMedicalExaminationImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> getEyePartDescribtion({
    required String language,
    required String userType,
    required String selectedEyePart,
  }) async {
    try {
      final response = await _eyesService.getEyePartDescribtion(
        language,
        userType,
        selectedEyePart,
      );

      return ApiResult.success(response['data']['description']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postEyeDataEntry({
    required String language,
    required String userType,
    required EyeDataEntryRequestBody requestBody,
  }) async {
    try {
      final response = await _eyesService.postEyeDataEntry(
        language,
        userType,
        requestBody,
      );

      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<EyePartSyptomsAndProceduresResponseModel>>
      getEyePartSyptomsAndProcedures({
    required String language,
    required String userType,
    required String selectedEyePart,
  }) async {
    try {
      final response = await _eyesService.getEyePartSyptomsAndProcedures(
        language,
        userType,
        selectedEyePart,
      );

      return ApiResult.success(
        EyePartSyptomsAndProceduresResponseModel.fromJson(response['data']),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editEyeDataEntered({
    required String id,
    required String language,
    required EyeDataEntryRequestBody requestBody,
  }) async {
    try {
      final response = await _eyesService.editEyeDataEntered(
        requestBody,
        id,
        language,
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
