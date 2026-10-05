import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificates_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class CertificatesRepo {
  final DoctorServices _doctorServices;

  CertificatesRepo(this._doctorServices);

  Future<ApiResult<String>> submitCertificates(
    CertificatesRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postCertificates(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
