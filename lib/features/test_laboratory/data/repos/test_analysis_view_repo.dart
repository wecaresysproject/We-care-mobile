import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
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

  Future<ApiResult<GetUserAnalysisReponseModel>> getTests() async {
    try {
      final response =
          await testAnalysisSerices.getUserTests(AppStrings.arabicLang);
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
}
