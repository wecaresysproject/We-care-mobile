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
    @Query('Language') String language,
  );
}
