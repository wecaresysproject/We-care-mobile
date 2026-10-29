import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/basic_data/data/models/doctor_basic_data_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class DoctorBasicDataRepo {
  final DoctorServices _doctorServices;

  DoctorBasicDataRepo(this._doctorServices);

  /// The doctor's saved basic data; null when the module wasn't filled yet.
  Future<ApiResult<DoctorBasicDataRequestBodyModel?>> getBasicData() async {
    try {
      final response = await _doctorServices.getBasicData();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(null);
      return ApiResult.success(DoctorBasicDataRequestBodyModel.fromJson(data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitBasicData(
    DoctorBasicDataRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postBasicData(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
