import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/surgeries/surgeries_api_constants.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';

part 'surgeries_services.g.dart';

@RestApi(baseUrl: SurgeriesApiConstants.baseUrl)
abstract class SurgeriesService {
  factory SurgeriesService(Dio dio, {String baseUrl}) = _SurgeriesService;

  @GET(SurgeriesApiConstants.getAllSurgeries)
  Future<GetUserSurgeriesResponseModal> getSurgeries(
    @Query("language") String language,
  );

  @GET(SurgeriesApiConstants.getSingleSurgery)
  Future<dynamic> getSurgeryById(
      @Query("id") String id, @Query("language") String language);

  @GET(SurgeriesApiConstants.getSurgeriesFilters)
  Future<dynamic> getFilters(@Query("language") String language);

  @GET(SurgeriesApiConstants.getFilteredSurgeries)
  Future<GetUserSurgeriesResponseModal> getFilteredSurgeries(
      @Query("language") String language,
      @Query("surgeryName") String? surgeryName,
      @Query("year") int? year);
}
