import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';
import 'package:we_care/features/supplements/supplements_api_constants.dart';

part 'supplements_services.g.dart';

@RestApi(baseUrl: SupplementsApiConstants.baseUrl)
abstract class SupplementsServices {
  factory SupplementsServices(Dio dio, {String baseUrl}) = _SupplementsServices;

  @GET(SupplementsApiConstants.getAvailableDateRanges)
  Future<dynamic> getAvailableDateRanges(
    @Query('language') String language,
  );

  @GET(SupplementsApiConstants.getEffectsOnNutrients)
  Future<dynamic> getEffectsOnNutrients(
    @Query('language') String language, {
    @Query('range') String? range,
  });

  @GET(SupplementsApiConstants.getVitaminsAndSupplements)
  Future<dynamic> getVitaminsAndSupplements(
    @Query('language') String language, {
    @Query('range') String? range,
  });

  @GET(SupplementsApiConstants.retrieveAvailableVitamins)
  Future<dynamic> retrieveAvailableVitamins(
    @Query('language') String language,
  );

  @POST(SupplementsApiConstants.submitSelectedSupplements)
  Future<dynamic> submitSelectedSupplements(
    @Body() List<SupplementEntry> supplements,
  );

  @GET(SupplementsApiConstants.getTrackedSupplementsAndVitamins)
  Future<dynamic> getTrackedSupplementsAndVitamins(
    @Query('language') String language,
  );

  @GET(SupplementsApiConstants.getPlanActivationStatus)
  Future<dynamic> getPlanActivationStatus(
    @Query('language') String language,
    @Query('planType') String planType,
  );

  @GET(SupplementsApiConstants.getAnyActivePlanStatus)
  Future<dynamic> getAnyActivePlanStatus();

  @GET(SupplementsApiConstants.getAllCreatedPlans)
  Future<GetAllCreatedPlansModel> getAllCreatedPlans(
    @Query('language') String language,
    @Query('planStatus') bool planActivationStatus,
    @Query('planType') String planType,
  );
}
