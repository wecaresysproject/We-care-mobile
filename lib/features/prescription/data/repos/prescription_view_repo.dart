import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
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

  Future<ApiResult<GetUserPrescriptionsResponseModel>> getUserPrescriptionList(
      {required String language}) async {
    try {
      final response =
          await prescriptionServices.getUserPrescriptionList(language);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  //get user prescription details by id
  Future<ApiResult<PrescriptionModel>> getUserPrescriptionDetailsById(
      {required String id,
      required String language,
      required String userType}) async {
    try {
      final response = await prescriptionServices
          .getUserPrescriptionDetailsById(id, language, userType);
      return ApiResult.success(PrescriptionModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
