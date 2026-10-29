import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/license_model.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/licenses_request_body_model.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class ProfessionalLicensesRepo {
  final DoctorServices _doctorServices;

  ProfessionalLicensesRepo(this._doctorServices);

  /// The doctor's saved licenses; empty when the module wasn't filled yet.
  Future<ApiResult<List<LicenseModel>>> getLicenses() async {
    try {
      final response = await _doctorServices.getLicenses();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(const []);
      return ApiResult.success(
        LicensesRequestBodyModel.fromJson(data).licenses,
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
