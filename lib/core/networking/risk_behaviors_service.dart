import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_api_constants.dart';

part 'risk_behaviors_service.g.dart';

@RestApi(baseUrl: RiskyBehaviorsApiConstants.baseUrl)
abstract class RiskBehaviorsServices {
  factory RiskBehaviorsServices(Dio dio, {String baseUrl}) =
      _RiskBehaviorsServices;

  @GET(RiskyBehaviorsApiConstants.riskyBehaviorsSections)
  Future<dynamic> getSections();

  @GET(RiskyBehaviorsApiConstants.riskyBehaviorsTypes)
  Future<dynamic> getTypes(
    @Query("section") String section,
  );

  @GET(RiskyBehaviorsApiConstants.riskyBehaviorsOptions)
  Future<dynamic> getOptions(
    @Query("section") String section,
    @Query("type") String type,
  );

  @POST(RiskyBehaviorsApiConstants.riskyBehaviorsSubmission)
  Future<dynamic> submitRiskyBehaviors(
    @Body() RiskyBehaviorDetailsModel body,
  );

  @GET(RiskyBehaviorsApiConstants.riskyBehaviorsSubmissions)
  Future<dynamic> getUserRiskBehaviorsData();

  @PUT(RiskyBehaviorsApiConstants.riskyBehaviorsSubmissions)
  Future<dynamic> updateRiskyBehaviors(
    @Query("id") String id,
    @Body() RiskyBehaviorDetailsModel body,
  );
}
