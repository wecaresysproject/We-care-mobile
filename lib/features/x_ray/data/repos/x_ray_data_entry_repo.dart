import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/x_ray/data/models/body_parts_response_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_data_entry_request_body_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_data_entry_response_model.dart';
import 'package:we_care/features/x_ray/xray_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class XRayDataEntryRepo {
  final XRayApiServices _xRayApiServices;

  XRayDataEntryRepo(this._xRayApiServices);

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

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _xRayApiServices.getCountries(language);
      final countries = (response['data'] as List)
          .map<CountryModel>((e) => CountryModel.fromJson(e))
          .toList();
      return ApiResult.success(countries);
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
