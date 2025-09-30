import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/nutration/data/models/get_all_created_plans_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
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
    @Query('date') String date,
  );
  @GET(NutrationApiConstants.getFoodAlternatives)
  Future<dynamic> getFoodAlternatives(
    @Query('language') String language,
    @Query('elementName') String elementName,
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

  @GET(NutrationApiConstants.getNutrationDocuments)
  Future<dynamic> getNutrationDocuments(
    @Query('language') String language,
    @Query('planType') String planType,
  );

  // @GET(NutrationApiConstants.getAllFilters)
  // Future<dynamic> getAllFilters(
  //     @Query('Language') String language, @Query('userType') String userType);

  // @GET(NutrationApiConstants.getFilteredBiometrics)
  // Future<dynamic> getFilteredBiometrics(
  //   @Query('Language') String language,
  //   @Query('userType') String userType,
  //   @Query('year') String? year,
  //   @Query('month') String? month,
  //   @Query('day') String? day,
  //   @Query('category') List<String> biometricCategories,
  // );
  // @GET(NutrationApiConstants.getCurrentBiometricData)
  // Future<dynamic> getCurrentBiometricData(
  //   @Query('Language') String language,
  //   @Query('userType') String userType,
  // );
}
