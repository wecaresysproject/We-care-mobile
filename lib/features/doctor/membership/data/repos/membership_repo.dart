import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/membership/data/models/memberships_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class MembershipRepo {
  final DoctorServices _doctorServices;

  MembershipRepo(this._doctorServices);

  Future<ApiResult<String>> submitMemberships(
    MembershipsRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postMemberships(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
