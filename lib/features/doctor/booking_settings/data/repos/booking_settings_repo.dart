import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_settings_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor "booking
/// settings" form — confirm the endpoint and request/response shape, then
/// replace this stub with a real Retrofit service call (see `AppSharedRepo`
/// for the wrapping pattern).
class BookingSettingsRepo {
  Future<ApiResult<String>> submitBookingSettings(
    BookingSettingsRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Booking settings submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
