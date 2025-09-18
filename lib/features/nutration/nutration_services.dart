import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/nutration/data/models/post_personal_nutrition_data_model.dart';
import 'package:we_care/features/nutration/nutration_api_constants.dart';

part 'nutration_services.g.dart';

@RestApi(baseUrl: NutrationApiConstants.baseUrl)
abstract class NutrationServices {
  factory NutrationServices(Dio dio, {String? baseUrl}) = _NutrationServices;

  @POST(NutrationApiConstants.postPersonalNutritionData)
  Future<dynamic> postPersonalNutritionData(
    @Body() PostPersonalNutritionData requestBody,
    @Query('Language') String language,
  );
  @GET(NutrationApiConstants.getAllChronicDiseases)
  Future<dynamic> getAllChronicDiseases(
    @Query('language') String language,
  );
  @GET(NutrationApiConstants.getAllChronicDiseases)
  Future<dynamic> getPlanActivationStatus(
    @Query('language') String language,
    @Query('planType') String planType,
  );

  // @GET(NutrationApiConstants.getAllAvailableBiometrics)
  // Future<dynamic> getAllAvailableBiometrics(
  //     @Query('Language') String language, @Query('userType') String userType);

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
