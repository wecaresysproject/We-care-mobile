import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/nutration/data/models/update_nutrition_value_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_api_constants.dart';

part 'physical_activaty_services.g.dart';

@RestApi(baseUrl: PhysicalActivatyApiConstants.baseUrl)
abstract class PhysicalActivityServices {
  factory PhysicalActivityServices(Dio dio, {String? baseUrl}) =
      _PhysicalActivityServices;

  @POST(PhysicalActivatyApiConstants.postPersonalUserInfoData)
  Future<dynamic> postPersonalUserInfoData(
    @Body() PostPersonalUserInfoData requestBody,
    @Query('Language') String language,
  );
  @POST(PhysicalActivatyApiConstants.postDailyDietPlan)
  Future<dynamic> postDailyDietPlan(
    @Body() NutrationFactsModel requestBody,
    @Query('language') String language,
    @Query('date') String date,
  );
  @GET(PhysicalActivatyApiConstants.getAllCreatedPlans)
  Future<GetAllCreatedPlansModel> getAllCreatedPlans(
    @Query('language') String language,
    @Query('planStatus') bool planActivationStatus,
    @Query('planType') String planType,
  );
  @GET(PhysicalActivatyApiConstants.getAllChronicDiseases)
  Future<dynamic> getAllChronicDiseases(
    @Query('language') String language,
  );
  @GET(PhysicalActivatyApiConstants.getPlanActivationStatus)
  Future<dynamic> getPlanActivationStatus(
    @Query('language') String language,
    @Query('planType') String planType,
  );

  @GET(PhysicalActivatyApiConstants.getAvailableYears)
  Future<dynamic> getAvailableYears(
    @Query('Language') String language,
  );

  @GET(PhysicalActivatyApiConstants.getAvailableDatesBasedOnYear)
  Future<dynamic> getAvailableDatesBasedOnYear(
    @Query('Language') String language,
    @Query('year') String year,
  );
  @GET(PhysicalActivatyApiConstants.getFilterdDocuments)
  Future<dynamic> getFilterdDocuments(
    @Query('language') String language,
    @Query('year') String year,
    @Query('date') String date,
  );

  @GET(PhysicalActivatyApiConstants.getPhysicalActivitySlides)
  Future<dynamic> getPhysicalActivitySlides(
    @Query('language') String language,
  );
  @PUT(PhysicalActivatyApiConstants.updateNutrientStandard)
  Future<dynamic> updateNutrientStandard(
    @Query('language') String language,
    @Body() UpdateNutritionValueModel requestBody,
    @Query('nutrientName') String nutrientName,
  );
  @GET(PhysicalActivatyApiConstants.getAnyActivePlanStatus)
  Future<dynamic> getAnyActivePlanStatus();

  @DELETE(PhysicalActivatyApiConstants.deleteDayDietPlan)
  Future<dynamic> deleteDayDietPlan(
    @Query("date") String date,
  );
}
