import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/service_prices/data/models/service_prices_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class ServicePricesRepo {
  final DoctorServices _doctorServices;

  ServicePricesRepo(this._doctorServices);

  /// The doctor's saved service prices; `null` when the module wasn't filled
  /// yet.
  Future<ApiResult<ServicePricesRequestBodyModel?>> getServicePrices() async {
    try {
      final response = await _doctorServices.getServicePrices();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(null);
      return ApiResult.success(ServicePricesRequestBodyModel.fromJson(data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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
