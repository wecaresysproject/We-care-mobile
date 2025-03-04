import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/test_laboratory/test_analysis_services.dart';

class TestAnalysisDataEntryRepo {
  final TestAnalysisSerices _testAnalysisServices;

  TestAnalysisDataEntryRepo(this._testAnalysisServices);

  Future<ApiResult<List<CountryModel>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _testAnalysisServices.getCountries(language);
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
