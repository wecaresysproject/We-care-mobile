import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_api_constants.dart';

part 'test_analysis_services.g.dart';

@RestApi(baseUrl: TestAnalysisApiConstants.baseUrl)
abstract class TestAnalysisSerices {
  factory TestAnalysisSerices(Dio dio, {String? baseUrl}) =
      _TestAnalysisSerices;

  @GET(TestAnalysisApiConstants.getCountries)
  Future<dynamic> getCountries(@Query('language') String language);

  @GET(TestAnalysisApiConstants.getYearsFilter)
  Future<dynamic> getYearsFilter();

  @GET(TestAnalysisApiConstants.getUserTests)
  Future<GetUserAnalysisReponseModel> getUserTests(
    @Query('language') String language,
  );

  @GET(TestAnalysisApiConstants.getFilteredTestsByYear)
  Future<GetUserAnalysisReponseModel> getFilteredTestsByYear(
    @Query('language') String language,
    @Query('year') int year,
  );

  @GET(TestAnalysisApiConstants.getTestbyId)
  Future<GetAnalysisByIdResponseModel> getTestbyId(
    @Query('id') String id,
    @Query('language') String language,
  );
}
