import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_request_body_model.dart';
import 'package:we_care/features/vaccine/vaccine_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class VaccineDataEntryRepo {
  final VaccineApiServices _vaccineApiServices;

  VaccineDataEntryRepo({required VaccineApiServices vaccineApiServices})
      : _vaccineApiServices = vaccineApiServices;

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _vaccineApiServices.getCountries(language);
      final countries = (response['data'] as List)
          .map<CountryModel>((e) => CountryModel.fromJson(e))
          .toList();
      return ApiResult.success(countries);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getVaccineCategories({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.getVaccineCategories(
        language,
        userType,
      );
      final categories = (response['data'] as List)
          .map<String>(
            (e) => e.toString(),
          )
          .toList();
      return ApiResult.success(categories);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<VaccineModel>>> getVaccineResultsByCategoryName({
    required String vaccineCategory,
    required String language,
    required String userType,
  }) async {
    try {
      final response =
          await _vaccineApiServices.getVaccineResultsByCategoryName(
        vaccineCategory,
        language,
        userType,
      );
      final vaccines = response["data"][0]["vaccines"];
      final vaccinesResponse = (vaccines as List)
          .map<VaccineModel>((e) => VaccineModel.fromJson(e))
          .toList();

      return ApiResult.success(vaccinesResponse);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postVaccineDataEntry({
    required VaccineModuleRequestBody requestBody,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _vaccineApiServices.postVaccineDataEntry(
        requestBody,
        language,
        userType,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
