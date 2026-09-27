import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/basic_data/data/models/doctor_basic_data_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor "basic
/// data" form — confirm the endpoint, request/response shape, and whether it
/// is one combined submission or per-section, then replace this stub with a
/// real Retrofit service call (see `AppSharedRepo` for the wrapping pattern).
class DoctorBasicDataRepo {
  Future<ApiResult<String>> submitBasicData(
    DoctorBasicDataRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Basic data submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
