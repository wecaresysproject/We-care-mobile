import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_settings_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class BookingSettingsRepo {
  final DoctorServices _doctorServices;

  BookingSettingsRepo(this._doctorServices);

  /// The doctor's saved booking settings; `null` when the module wasn't
  /// filled yet.
  Future<ApiResult<BookingSettingsRequestBodyModel?>>
      getBookingSettings() async {
    try {
      final response = await _doctorServices.getBookingSettings();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(null);
      return ApiResult.success(BookingSettingsRequestBodyModel.fromJson(data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
