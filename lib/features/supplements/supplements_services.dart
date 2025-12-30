import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/supplements/supplements_api_constants.dart';

part 'supplements_services.g.dart';

@RestApi(baseUrl: SupplementsApiConstants.baseUrl)
abstract class SupplementsServices {
  factory SupplementsServices(Dio dio, {String baseUrl}) = _SupplementsServices;

  @GET(SupplementsApiConstants.getAvailableDateRanges)
  Future<dynamic> getAvailableDateRanges(
    @Query('language') String language,
  );
}
