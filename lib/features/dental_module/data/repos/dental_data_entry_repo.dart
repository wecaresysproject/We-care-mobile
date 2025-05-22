import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/dental_services.dart';

class DentalDataEntryRepo {
  final DentalService _dentalService;

  DentalDataEntryRepo({required DentalService dentalService})
      : _dentalService = dentalService;

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _dentalService.getCountries(language);
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
      final response = await _dentalService.uploadReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllMainMedicalProcedure({
    required String userType,
    required String language,
  }) async {
    try {
      final response = await _dentalService.getAllMainMedicalProcedures(
        userType,
        language,
      );
      final procedures = (response['data'] as List)
          .map<String>(
            (e) => e.toString(),
          )
          .toList();
      return ApiResult.success(procedures);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllSecondaryMedicalProcedure({
    required String mainProcedure,
    required String userType,
    required String language,
  }) async {
    try {
      final response = await _dentalService.getAllSecondaryMedicalProcedure(
        mainProcedure,
        userType,
        language,
      );
      final secondaryProcedures = (response['data'] as List)
          .map<String>(
            (e) => e.toString(),
          )
          .toList();
      return ApiResult.success(secondaryProcedures);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<String>> postModuleData({
  //   required String language,
  //   required SurgeryRequestBodyModel requestBody,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.postSurgeryData(
  //       language,
  //       requestBody,
  //     );
  //     return ApiResult.success(response["message"]);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> updateSurgeryDocumentById({
  //   required String id,
  //   required String langauge,
  //   required SurgeryRequestBodyModel requestBody,
  // }) async {
  //   try {
  //     final response = await _.updateSurgeryDocumentById(
  //       id,
  //       langauge,
  //       requestBody,
  //     );
  //     return ApiResult.success(response["message"]);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
