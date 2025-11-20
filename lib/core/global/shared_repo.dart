import 'dart:io';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';

class AppSharedRepo {
  final SharedServices _sharedServices;
  AppSharedRepo(this._sharedServices);
  Future<ApiResult<List<String>>> getDoctorsSpecializations({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _sharedServices.getDoctorsSpecializations(
        userType,
        language,
      );
      final specializations =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(specializations);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getCountriesData({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getCountriesNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final countries = (response['data'] as List)
          .map((country) => country as String)
          .toList();
      return ApiResult.success(countries);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getHospitalNames({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getHospitalNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final hospitals = (response['data'] as List)
          .map((hospital) => hospital as String)
          .toList();
      return ApiResult.success(hospitals);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getCitiesBasedOnCountryName(
      {required String language, required String countryName}) async {
    try {
      final response = await _sharedServices.getCitiesBasedOnCountryName(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
        countryName,
      );
      final cityNames =
          (response['data'] as List).map((city) => city as String).toList();
      return ApiResult.success(cityNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getRadiologyCenters(
      {required String language}) async {
    try {
      final response = await _sharedServices.getRadiologyCenters(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final radiologyCenters =
          (response['data'] as List).map((center) => center as String).toList();
      return ApiResult.success(radiologyCenters);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getDentalMedicalCenters(
      {required String language}) async {
    try {
      final response = await _sharedServices.getDentalMedicalCenters(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final dentalCenters =
          (response['data'] as List).map((center) => center as String).toList();
      return ApiResult.success(dentalCenters);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getEyeMedicalCenters(
      {required String language}) async {
    try {
      final response = await _sharedServices.getEyeMedicalCenters(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final eyeCenters =
          (response['data'] as List).map((center) => center as String).toList();
      return ApiResult.success(eyeCenters);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getLabCenters({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getLabCenters(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final labs =
          (response['data'] as List).map((lab) => lab as String).toList();
      return ApiResult.success(labs);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getDiseasesNames({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getDiseasesNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final diseases = (response['data'] as List)
          .map((disease) => disease as String)
          .toList();
      return ApiResult.success(diseases);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllDoctors({
    required String language,
    required String userType,
    String? specialization,
  }) async {
    try {
      final response = await _sharedServices.getDoctorNames(
        userType,
        language,
        specialization,
      );
      final doctors = (response['data'] as List)
          .map<Doctor>((e) => Doctor.fromJson(e))
          .toList();
      final doctorNames = doctors.map((e) => e.fullName).toList();
      return ApiResult.success(doctorNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _sharedServices.uploadImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadReportResponseModel>> uploadReport({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _sharedServices.uploadReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
