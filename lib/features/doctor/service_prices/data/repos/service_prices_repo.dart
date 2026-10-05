import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/service_prices/data/models/service_prices_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';

class ServicePricesRepo {
  final DoctorServices _doctorServices;

  ServicePricesRepo(this._doctorServices);

  Future<ApiResult<String>> submitServicePrices(
    ServicePricesRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postServicePrices(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
