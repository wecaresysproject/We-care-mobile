import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/membership/data/models/membership_model.dart';
import 'package:we_care/features/doctor/membership/data/models/memberships_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class MembershipRepo {
  final DoctorServices _doctorServices;

  MembershipRepo(this._doctorServices);

  /// The doctor's saved memberships; empty when the module wasn't filled yet.
  Future<ApiResult<List<MembershipModel>>> getMemberships() async {
    try {
      final response = await _doctorServices.getMemberships();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(const []);
      return ApiResult.success(
        MembershipsRequestBodyModel.fromJson(data).memberships,
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
