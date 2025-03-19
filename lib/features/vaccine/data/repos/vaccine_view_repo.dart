import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_filters_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_services.dart';

class VaccineViewRepo {
  final VaccineApiServices vaccineApiServices;

  VaccineViewRepo(this.vaccineApiServices);

  Future<ApiResult<GetUserVaccinesResponseModel>> getUserVaccines(
      String language, String userType) async {
    try {
      final response =
          await vaccineApiServices.getUserVaccines(language, userType);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<GetUserVaccinesResponseModel>> getFilteredList(
      String language,
      String userType,
      String? vaccineName,
      String? year) async {
    try {
      final response = await vaccineApiServices.getFilteredList(
          language, userType, vaccineName, year);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<UserVaccineModel>> getVaccineById(
      String language, String userType, String vaccineId) async {
    try {
      final response = await vaccineApiServices.getVaccineById(
          language, vaccineId, userType);
      return ApiResult.success(UserVaccineModel.fromJson(response['data']));
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<String>> deleteVaccineById(
      String language, String userType, String vaccineId) async {
    try {
      final response =
          await vaccineApiServices.deleteVaccine(language, userType, vaccineId);
      return ApiResult.success(response['message']);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<VaccinesFiltersResponseModel>> getVaccinesFilters(
      String language, String userType) async {
    try {
      final response =
          await vaccineApiServices.getVaccinesFilters(language, userType);
      return ApiResult.success(
          VaccinesFiltersResponseModel.fromJson(response['data']));
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
