import 'dart:developer';
import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/features/prescription/prescription_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class PrescriptionDataEntryRepo {
  final PrescriptionServices _prescriptionServices;

  PrescriptionDataEntryRepo(this._prescriptionServices);

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _prescriptionServices.getCountries(
        language,
      );
      final countries = (response['data'] as List)
          .map<CountryModel>((e) => CountryModel.fromJson(e))
          .toList();
      return ApiResult.success(countries);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getCitiesBasedOnCountryName(
      {required String language, required String CityName}) async {
    try {
      final response = await _prescriptionServices.getCitiesByCountryName(
        language,
        CityName,
      );
      final cityNames = (response['data'] as List)
          .map((city) => city['name'] as String)
          .toList();
      log("xxx: cityNames from repo: $cityNames");
      return ApiResult.success(cityNames);
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
        language,
        contentType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
