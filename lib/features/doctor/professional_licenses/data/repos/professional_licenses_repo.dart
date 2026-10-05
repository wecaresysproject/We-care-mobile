import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/licenses_request_body_model.dart';

class ProfessionalLicensesRepo {
  final DoctorServices _doctorServices;

  ProfessionalLicensesRepo(this._doctorServices);

  Future<ApiResult<String>> submitLicenses(
    LicensesRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postLicenses(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
