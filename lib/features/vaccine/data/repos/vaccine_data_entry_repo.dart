import 'package:we_care/core/models/country_response_model.dart';
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

  // Future<ApiResult<UploadImageResponseModel>> uploadRadiologyImage({
  //   required String language,
  //   required String contentType,
  //   required File image,
  // }) async {
  //   try {
  //     final response = await _xRayApiServices.uploadRadiologyImage(
  //       image,
  //       contentType,
  //       language,
  //     );
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<UploadReportResponseModel>> uploadRadiologyReportImage({
  //   required String language,
  //   required String contentType,
  //   required File image,
  // }) async {
  //   try {
  //     final response = await _xRayApiServices.uploadRadiologyReportImage(
  //       image,
  //       contentType,
  //       language,
  //     );
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
