import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/medical_specialty/data/models/medical_specialty_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class MedicalSpecialtyRepo {
  final DoctorServices _doctorServices;

  MedicalSpecialtyRepo(this._doctorServices);

  Future<ApiResult<String>> submitMedicalSpecialty(
    MedicalSpecialtyRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postMedicalSpecialty(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
