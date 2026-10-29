import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/experience/data/models/experience_model.dart';
import 'package:we_care/features/doctor/experience/data/models/experiences_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class ExperienceRepo {
  final DoctorServices _doctorServices;

  ExperienceRepo(this._doctorServices);

  /// The doctor's saved experiences; empty when the module wasn't filled yet.
  Future<ApiResult<List<ExperienceModel>>> getExperiences() async {
    try {
      final response = await _doctorServices.getExperiences();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(const []);
      return ApiResult.success(
          ExperiencesRequestBodyModel.fromJson(data).experiences);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitExperiences(
    ExperiencesRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postExperiences(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
