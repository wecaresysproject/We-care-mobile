import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/quality_of_life/data/models/answered_questions_response.dart';
import 'package:we_care/features/quality_of_life/data/models/quality_of_life_questionnaire_response.dart';
import 'package:we_care/features/quality_of_life/data/models/quality_of_life_submit_request.dart';
import 'package:we_care/features/quality_of_life/data/models/quality_of_life_submit_response.dart';
import 'package:we_care/features/quality_of_life/quality_of_life_api_constants.dart';

part 'quality_of_life_services.g.dart';

@RestApi(baseUrl: QualityOfLifeApiConstants.baseUrl)
abstract class QualityOfLifeServices {
  factory QualityOfLifeServices(Dio dio, {String baseUrl}) =
      _QualityOfLifeServices;

  @GET(QualityOfLifeApiConstants.fetchQuestionnaire)
  Future<QualityOfLifeQuestionnaireResponse> fetchQuestionnaire();

  @POST(QualityOfLifeApiConstants.submitAssessment)
  Future<QualityOfLifeSubmitResponse> submitAssessment(
    @Body() QualityOfLifeSubmitRequest request,
  );

  @GET(QualityOfLifeApiConstants.getAnsweredQuestions)
  Future<AnsweredQuestionsResponse> getAnsweredQuestions(
    @Query('dateRange') String? dateRange,
  );

  @GET(QualityOfLifeApiConstants.getDateRanges)
  Future<dynamic> getDateRanges();
}
