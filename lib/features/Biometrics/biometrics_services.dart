import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/Biometrics/biometrics_api_constants.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';

part 'biometrics_services.g.dart';

@RestApi(baseUrl: BiometricsApiConstants.baseUrl)
abstract class BiometricsServices {
  factory BiometricsServices(Dio dio, {String? baseUrl}) = _BiometricsServices;

  @POST(BiometricsApiConstants.postBiometricDataOfSpecifcCategory)
  Future<dynamic> postBiometricDataOfSpecifcCategory(
    @Body() PostBiometricCategoryModel requestBody,
    @Query('userType') String userType,
    @Query('Language') String language,);
    
  @GET(BiometricsApiConstants.getAllAvailableBiometrics)
  Future<dynamic> getAllAvailableBiometrics(
      @Query('Language') String language, 
      @Query('userType') String userType
  );

  @GET(BiometricsApiConstants.getAllFilters)
  Future<dynamic> getAllFilters(
      @Query('Language') String language, 
      @Query('userType') String userType
  );

  @GET(BiometricsApiConstants.getFilteredBiometrics)
  Future<dynamic> getFilteredBiometrics(
      @Query('Language') String language, 
      @Query('userType') String userType, 
      @Query('year') String? year, 
      @Query('month') String? month, 
      @Query('day') String? day, 
      @Query('category') List<String> biometricCategories,
  );
  @GET(BiometricsApiConstants.getCurrentBiometricData)
  Future<dynamic> getCurrentBiometricData(
      @Query('Language') String language, 
      @Query('userType') String userType,);
}
