import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/nutration/data/models/update_nutrition_value_model.dart';
import 'package:we_care/features/nutration/nutration_api_constants.dart';

part 'nutration_services.g.dart';

@RestApi(baseUrl: NutrationApiConstants.baseUrl)
abstract class NutrationServices {
  factory NutrationServices(Dio dio, {String? baseUrl}) = _NutrationServices;

  @POST(NutrationApiConstants.postPersonalUserInfoData)
  Future<dynamic> postPersonalUserInfoData(
    @Body() PostPersonalUserInfoData requestBody,
    @Query('Language') String language,
  );
  @POST(NutrationApiConstants.postDailyDietPlan)
  Future<dynamic> postDailyDietPlan(
    @Body() NutrationFactsModel requestBody,
    @Query('language') String language,
    @Query('date') String date,
  );
  @GET(NutrationApiConstants.getAllCreatedPlans)
  Future<GetAllCreatedPlansModel> getAllCreatedPlans(
    @Query('language') String language,
    @Query('planStatus') bool planActivationStatus,
    @Query('planType') String planType,
  );
  @GET(NutrationApiConstants.getAllChronicDiseases)
  Future<dynamic> getAllChronicDiseases(
    @Query('language') String language,
  );
  @GET(NutrationApiConstants.getPlanActivationStatus)
  Future<dynamic> getPlanActivationStatus(
    @Query('language') String language,
    @Query('planType') String planType,
  );

  @GET(NutrationApiConstants.getAllNutrationTableData)
  Future<dynamic> getAllNutrationTableData(
    @Query('Language') String language,
    @Query('date') String? date,
  );
  @GET(NutrationApiConstants.getFoodAlternatives)
  Future<dynamic> getFoodAlternatives(
    @Query('language') String language,
    @Query('elementName') String elementName,
  );

  @GET(NutrationApiConstants.getElementRecommendations)
  Future<dynamic> getElementRecommendations(
    @Query('language') String language,
    @Query('elementName') String elementName,
  );

  @GET(NutrationApiConstants.getAffectedOrgansList)
  Future<dynamic> getAffectedOrgansList(
    @Query('language') String language,
  );
  @GET(NutrationApiConstants.getOrganNutritionalEffects)
  Future<dynamic> getOrganNutritionalEffects(
    @Query('language') String language,
    @Query('organName') String organName,
  );

  @GET(NutrationApiConstants.getAvailableYearsForWeeklyPlan)
  Future<dynamic> getAvailableYearsForWeeklyPlan(
    @Query('Language') String language,
  );
  @GET(NutrationApiConstants.getAvailableYearsForMonthlyPlan)
  Future<dynamic> getAvailableYearsForMonthlyPlan(
    @Query('Language') String language,
  );
  @GET(NutrationApiConstants.getAvailableDateRangesForWeeklyPlan)
  Future<dynamic> getAvailableDateRangesForWeeklyPlan(
    @Query('Language') String language,
    @Query('year') String year,
  );
  @GET(NutrationApiConstants.getAvailableDateRangesForMonthlyPlan)
  Future<dynamic> getAvailableDateRangesForMonthlyPlan(
    @Query('Language') String language,
    @Query('year') String year,
  );
  @GET(NutrationApiConstants.getFilterdNutritionDocuments)
  Future<dynamic> getFilterdNutritionDocuments(
    @Query('language') String language,
    @Query('year') String year,
    @Query('rangeDate') String rangeDate,
    @Query('planType') String planType,
  );

  @GET(NutrationApiConstants.getNutrationDocuments)
  Future<dynamic> getNutrationDocuments(
    @Query('language') String language,
    @Query('planType') String planType,
  );
  @PUT(NutrationApiConstants.updateNutrientStandard)
  Future<dynamic> updateNutrientStandard(
    @Query('language') String language,
    @Body() UpdateNutritionValueModel requestBody,
    @Query('nutrientName') String nutrientName,
  );
  @GET(NutrationApiConstants.getAnyActivePlanStatus)
  Future<dynamic> getAnyActivePlanStatus();

  @DELETE(NutrationApiConstants.deleteDayDietPlan)
  Future<dynamic> deleteDayDietPlan(
    @Query("date") String date,
  );
}
