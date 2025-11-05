import 'dart:io';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/x_ray/data/models/body_parts_response_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_data_entry_request_body_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_data_entry_response_model.dart';
import 'package:we_care/features/x_ray/xray_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class XRayDataEntryRepo {
  final XRayApiServices _xRayApiServices;
  final SharedServices _sharedServices;

  XRayDataEntryRepo(this._xRayApiServices, this._sharedServices);

  Future<ApiResult<List<BodyPartsResponseModel>>> getBodyPartsData() async {
    try {
      final response = await _xRayApiServices.getBodyPartsData();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<BodyPartsResponseModel>> getRadiologyTypeByBodyPartId(
      String id) async {
    try {
      final response = await _xRayApiServices.getRadiologyTypeByBodyPartId(id);
      return ApiResult.success(
        BodyPartsResponseModel.fromJson(response['data']),
      );
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
      return ApiResult.success(countries);
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

  Future<ApiResult<XrayDataEntryResponseBodyModel>> postRadiologyDataEntry(
      XrayDataEntryRequestBodyModel requestBody) async {
    try {
      final response =
          await _xRayApiServices.postRadiologyDataEntry(requestBody);
      return ApiResult.success(
        XrayDataEntryResponseBodyModel.fromJson(
          response['data'],
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadRadiologyImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _xRayApiServices.uploadRadiologyImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadReportResponseModel>> uploadRadiologyReportImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _xRayApiServices.uploadRadiologyReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> updateXRayDocumentDetails({
    required requestBody,
    required String documentId,
  }) async {
    try {
      final response = await _xRayApiServices.updateRadiologyDocumentDetails(
        requestBody,
        requestBody.language,
        documentId,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
