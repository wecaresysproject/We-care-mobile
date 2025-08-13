import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_services.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';

class ChronicDiseaseViewRepo {
  final ChronicDiseaseServices diseaseServices;
  ChronicDiseaseViewRepo({required this.diseaseServices});

  // Future<ApiResult<PrescriptionFiltersResponseModel>> getFilters(
  //     {required String language, required String userType}) async {
  //   try {
  //     final response =
  //         await diseaseServices.getPrescriptionFilters(language, userType);
  //     return ApiResult.success(
  //         PrescriptionFiltersResponseModel.fromJson(response['data']));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  Future<ApiResult<GetUserPrescriptionsResponseModel>> getUserPrescriptionList(
      {required String language,
      required String userType,
      int? page,
      int? pageSize}) async {
    try {
      final response = await diseaseServices.getUserPrescriptionList(
          language, userType,
          page: page, pageSize: pageSize);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<PrescriptionModel>> getUserPrescriptionDetailsById(
      {required String id,
      required String language,
      required String userType}) async {
    try {
      final response = await diseaseServices.getUserPrescriptionDetailsById(
          id, language, userType);
      return ApiResult.success(PrescriptionModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deletePrescriptionById(
      {required String id,
      required String language,
      required String userType}) async {
    try {
      final response =
          await diseaseServices.deletePrescriptionById(id, language, userType);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<GetUserPrescriptionsResponseModel>>
  //     getFilteredPrescriptionList(
  //         {required String language,
  //         required String userType,
  //         int? year,
  //         String? doctorName,
  //         String? specification}) async {
  //   try {
  //     final response = await diseaseServices.getFilteredPrescriptionList(
  //         language: language,
  //         userType: userType,
  //         year: year,
  //         doctorName: doctorName,
  //         specialization: specification);

  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
