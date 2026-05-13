import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/quality_of_life/data/models/answered_questions_response.dart';
import 'package:we_care/features/quality_of_life/data/models/quality_of_life_questionnaire_response.dart';
import 'package:we_care/features/quality_of_life/data/models/quality_of_life_submit_request.dart';
import 'package:we_care/features/quality_of_life/quality_of_life_services.dart';

class QualityOfLifeRepo {
  final QualityOfLifeServices _qualityOfLifeServices;

  QualityOfLifeRepo(this._qualityOfLifeServices);

  Future<ApiResult<QualityOfLifeQuestionnaireResponse>>
      fetchQuestionnaire() async {
    try {
      final response = await _qualityOfLifeServices.fetchQuestionnaire();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitAssessment(
    QualityOfLifeSubmitRequest request,
  ) async {
    try {
      final response = await _qualityOfLifeServices.submitAssessment(request);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AnsweredQuestionsResponse>> fetchAnsweredQuestions(
    String? dateFrom,
    String? dateTo,
  ) async {
    try {
      final response =
          await _qualityOfLifeServices.getAnsweredQuestions(dateFrom, dateTo);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> fetchUserSubmissionDates() async {
    try {
      final response = await _qualityOfLifeServices.getUserSubmissionDates();
      return ApiResult.success(List<String>.from(response["data"]));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
