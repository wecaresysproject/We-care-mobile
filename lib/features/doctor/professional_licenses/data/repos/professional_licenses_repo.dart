import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/licenses_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor
/// "professional licenses" form — confirm the endpoint and request/response
/// shape, then replace this stub with a real Retrofit service call (see
/// `AppSharedRepo` for the wrapping pattern).
class ProfessionalLicensesRepo {
  Future<ApiResult<String>> submitLicenses(
    LicensesRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Professional licenses submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
