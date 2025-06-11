import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/Biometrics/biometrics_services.dart';

class BiometricsDataEntryRepo {
  final BiometricsServices _biometricsServices;

  BiometricsDataEntryRepo(this._biometricsServices);

  Future<ApiResult<String>> postBiometricsDataEntry({
    required String categoryName,
    required String value,
    required String unit,
  }) async {
    return Future.delayed(
        const Duration(seconds: 2), () => ApiResult.success("success"));
  }
}
