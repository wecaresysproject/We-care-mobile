import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/dental_module/dental_services.dart';

class DentalDataEntryRepo {
  final DentalService _dentalService;

  DentalDataEntryRepo({required DentalService dentalService})
      : _dentalService = dentalService;

  Future<ApiResult<UploadReportResponseModel>> uploadTeethReport({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _dentalService.uploadTeethReport(
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

  Future<ApiResult<List<String>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _dentalService.getCountries(language);
      final countries = (response['data'] as List)
          .map<CountryModel>((e) => CountryModel.fromJson(e))
          .toList();
      final countriesNames = countries.map((e) => e.name).toList();
      return ApiResult.success(countriesNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllDoctors({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _dentalService.getAllDoctors(
        userType,
        language,
      );
      final countries = (response['data'] as List)
          .map<Doctor>((e) => Doctor.fromJson(e))
          .toList();
      final doctorNames = countries.map((e) => e.fullName).toList();
      return ApiResult.success(doctorNames);
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
