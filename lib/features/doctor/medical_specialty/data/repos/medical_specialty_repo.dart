import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/medical_specialty/data/models/medical_specialty_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class MedicalSpecialtyRepo {
  final DoctorServices _doctorServices;

  MedicalSpecialtyRepo(this._doctorServices);

  /// The doctor's saved medical specialty; null when the module wasn't filled
  /// yet.
  Future<ApiResult<MedicalSpecialtyRequestBodyModel?>>
      getMedicalSpecialty() async {
    try {
      final response = await _doctorServices.getMedicalSpecialty();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(null);
      return ApiResult.success(MedicalSpecialtyRequestBodyModel.fromJson(data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
