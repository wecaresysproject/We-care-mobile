import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/service_prices/data/models/service_prices_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor "service
/// prices" form — confirm the endpoint and request/response shape, then
/// replace this stub with a real Retrofit service call (see `AppSharedRepo`
/// for the wrapping pattern).
class ServicePricesRepo {
  Future<ApiResult<String>> submitServicePrices(
    ServicePricesRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Service prices submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
