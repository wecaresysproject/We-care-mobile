import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/basic_data/data/models/doctor_basic_data_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class DoctorBasicDataRepo {
  final DoctorServices _doctorServices;

  DoctorBasicDataRepo(this._doctorServices);

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
