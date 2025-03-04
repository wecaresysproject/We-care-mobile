import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/test_laboratory/test_analysis_api_constants.dart';

part 'test_analysis_services.g.dart';

@RestApi(baseUrl: TestAnalysisApiConstants.baseUrl)
abstract class TestAnalysisSerices {
  factory TestAnalysisSerices(Dio dio, {String? baseUrl}) =
      _TestAnalysisSerices;

  @GET(TestAnalysisApiConstants.getCountries)
  Future<dynamic> getCountries(@Query('language') String language);
}
