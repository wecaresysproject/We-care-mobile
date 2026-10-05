import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_settings_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class BookingSettingsRepo {
  final DoctorServices _doctorServices;

  BookingSettingsRepo(this._doctorServices);

  Future<ApiResult<String>> submitBookingSettings(
    BookingSettingsRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postBookingSettings(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
