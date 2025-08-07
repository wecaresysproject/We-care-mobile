import 'dart:developer';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_services.dart';
import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class ChronicDiseaseDataEntryRepo {
  final ChronicDiseaseServices _services;

  ChronicDiseaseDataEntryRepo(this._services);

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _services.getCountries(
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
      {required String language, required String cityName}) async {
    try {
      final response = await _services.getCitiesByCountryName(
        language,
        cityName,
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

  Future<ApiResult<String>> postPrescriptionDataEntry(
      PrescriptionRequestBodyModel requestBody) async {
    try {
      final response = await _services.postPrescriptionDataEntry(requestBody);
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
      final response = await _services.updatePrescriptionDocumentDetails(
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
