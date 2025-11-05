import 'dart:developer';
import 'dart:io';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';
import 'package:we_care/features/prescription/prescription_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class PrescriptionDataEntryRepo {
  final PrescriptionServices _prescriptionServices;
  final SharedServices _sharedServices;

  PrescriptionDataEntryRepo(this._prescriptionServices, this._sharedServices);

  Future<ApiResult<List<String>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _sharedServices.getCountriesNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final countries = (response['data'] as List)
          .map((country) => country as String)
          .toList();
      log("xxx: countries from repo: $countries");
      return ApiResult.success(countries);
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
      log("xxx: cityNames from repo: $cityNames");
      return ApiResult.success(cityNames);
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
  }) async {
    try {
      final response = await _sharedServices.getDoctorNames(
        userType,
        language,
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

  Future<ApiResult<UploadImageResponseModel>> uploadPrescriptionImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _prescriptionServices.uploadPrescriptionImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postPrescriptionDataEntry(
      PrescriptionRequestBodyModel requestBody) async {
    try {
      final response =
          await _prescriptionServices.postPrescriptionDataEntry(requestBody);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> updatePrescriptionDocumentDetails({
    required PrescriptionRequestBodyModel requestBody,
    required String documentId,
  }) async {
    try {
      final response =
          await _prescriptionServices.updatePrescriptionDocumentDetails(
        requestBody,
        requestBody.language,
        requestBody.userType,
        documentId,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
