import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_model.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_section_type.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificates_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class CertificatesRepo {
  final DoctorServices _doctorServices;

  CertificatesRepo(this._doctorServices);

  /// The doctor's saved certificates per section; every section is empty when
  /// the module wasn't filled yet.
  Future<ApiResult<Map<CertificateSectionType, List<CertificateModel>>>>
      getCertificates() async {
    try {
      final response = await _doctorServices.getCertificates();
      final data = profileResponseData(response);
      return ApiResult.success(
        CertificatesRequestBodyModel.fromJson(
          data is Map<String, dynamic> ? data : const {},
        ).sections,
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
