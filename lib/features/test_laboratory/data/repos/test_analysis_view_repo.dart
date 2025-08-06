import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/test_laboratory/data/models/delete_analysis_document_response.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_similar_tests_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_services.dart';

class TestAnalysisViewRepo {
  final TestAnalysisSerices testAnalysisSerices;

  TestAnalysisViewRepo(this.testAnalysisSerices);

  Future<ApiResult<List<int>>> gettFilters() async {
    try {
      final response = await testAnalysisSerices.getYearsFilter();
      return ApiResult.success(
          (response["data"] as List).map((e) => e as int).toList());
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetUserAnalysisReponseModel>> getTests(
      {int? page, int? pageSize}) async {
    try {
      final response = await testAnalysisSerices.getUserTests(
          AppStrings.arabicLang, 'Patient', page ?? 1, pageSize ?? 10);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetUserAnalysisReponseModel>> getTestsByYear(
      int year) async {
    try {
      final response = await testAnalysisSerices.getFilteredTestsByYear(
          AppStrings.arabicLang, year);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetAnalysisByIdResponseModel>> getTestbyId(String id) async {
    try {
      final response =
          await testAnalysisSerices.getTestbyId(id, AppStrings.arabicLang);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DeleteAnalysisDocumentResponse>> deleteAnalysisById(
      String id, string, String language, String testName) async {
    try {
      final response =
          await testAnalysisSerices.deleteAnalysisById(id, language, testName);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editTestResultByIdAndName(
      {required String id,
      required String testName,
      required double result}) async {
    try {
      final response = await testAnalysisSerices.editTestResultByIdAndName(
          id, AppStrings.arabicLang, testName, {"writtenPercent": result});
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  //get similar tests
  Future<ApiResult<GetSimilarTestsResponseModel>> getSimilarTests(
      {required String query}) async {
    try {
      final response = await testAnalysisSerices.getSimilarTests(
          AppStrings.arabicLang, query);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
