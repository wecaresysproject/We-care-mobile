import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificates_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor
/// "scientific certificates" form — confirm the endpoint and request/response
/// shape, then replace this stub with a real Retrofit service call (see
/// `AppSharedRepo` for the wrapping pattern).
class CertificatesRepo {
  Future<ApiResult<String>> submitCertificates(
    CertificatesRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Certificates submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
