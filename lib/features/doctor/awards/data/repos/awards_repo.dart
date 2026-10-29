import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/awards/data/models/award_model.dart';
import 'package:we_care/features/doctor/awards/data/models/awards_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class AwardsRepo {
  final DoctorServices _doctorServices;

  AwardsRepo(this._doctorServices);

  /// The doctor's saved awards; empty when the module wasn't filled yet.
  Future<ApiResult<List<AwardModel>>> getAwards() async {
    try {
      final response = await _doctorServices.getAwards();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(const []);
      return ApiResult.success(AwardsRequestBodyModel.fromJson(data).awards);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitAwards(
    AwardsRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postAwards(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
