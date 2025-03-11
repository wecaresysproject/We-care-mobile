import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/prescription/data/models/prescription_filters_response_model.dart';
import 'package:we_care/features/prescription/prescription_services.dart';

class PrescriptionViewRepo {
  final PrescriptionServices prescriptionServices;
  PrescriptionViewRepo({required this.prescriptionServices});

  Future<ApiResult<PrescriptionFiltersResponseModel>> gettFilters(
      {required String language, required String userType}) async {
    try {
      final response =
          await prescriptionServices.getPrescriptionFilters(language, userType);
      return ApiResult.success(
          PrescriptionFiltersResponseModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
