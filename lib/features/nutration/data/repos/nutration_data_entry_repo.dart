import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/Biometrics/data/models/post_biometric_data_of_specifc_category_model.dart';
import 'package:we_care/features/nutration/nutration_services.dart';

class NutrationDataEntryRepo {
  final NutrationServices _nutrationServices;

  NutrationDataEntryRepo(this._nutrationServices);

  Future<ApiResult<String>> postNutrationDataEntry({
    required PostBiometricCategoryModel requestBody,
    required String lanugage,
    required String userType,
  }) async {
    try {
      final response =
          await _nutrationServices.postBiometricDataOfSpecifcCategory(
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
