import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/Biometrics/biometrics_services.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';

class BiometricsDataEntryRepo {
  final BiometricsServices _biometricsServices;

  BiometricsDataEntryRepo(this._biometricsServices);

  Future<ApiResult<String>> postBiometricsDataEntry({
    required PostBiometricCategoryModel requestBody,
    required String lanugage,
    required String userType,
  }) async {
    try {
      final response =
          await _biometricsServices.postBiometricDataOfSpecifcCategory(
        requestBody,
        userType,
        lanugage,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
