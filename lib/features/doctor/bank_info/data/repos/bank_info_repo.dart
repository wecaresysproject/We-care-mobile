import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/bank_info/data/models/bank_info_request_body_model.dart';

/// TODO: no backend contract exists yet for submitting the doctor "bank
/// info" form — confirm the endpoint and request/response shape, then
/// replace this stub with a real Retrofit service call (see `AppSharedRepo`
/// for the wrapping pattern).
class BankInfoRepo {
  Future<ApiResult<String>> submitBankInfo(
    BankInfoRequestBodyModel model,
  ) async {
    try {
      throw UnimplementedError(
        'Bank info submission endpoint is not defined yet.',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
