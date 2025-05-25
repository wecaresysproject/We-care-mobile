import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
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

  Future<ApiResult<UploadImageResponseModel>> uploadXrayImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _dentalService.uploadXrayImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadLymphAnalysisImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _dentalService.uploadLymphAnalysisImage(
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

  Future<ApiResult<List<String>>> getAllComplainTypes({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _dentalService.getAllComplainTypes(
        userType,
        language,
      );
      final complainTypes =
          (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(complainTypes);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllComplainNatures({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _dentalService.getAllComplainNatures(
        userType,
        language,
      );
      final complainNatures =
          (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(complainNatures);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllComaplainsDurations({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _dentalService.getAllComaplainsDurations(
        userType,
        language,
      );
      final complainDurations =
          (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(complainDurations);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllGumsconditions({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _dentalService.getAllGumsconditions(
        userType,
        language,
      );
      final allGumsConditions =
          (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(allGumsConditions);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllOralMedicalTests({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _dentalService.getAllOralMedicalTests(
        userType,
        language,
      );
      final allOralMedicalTests =
          (response['data'] as List).map((e) => e.toString()).toList();
      return ApiResult.success(allOralMedicalTests);
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
