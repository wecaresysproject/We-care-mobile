import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/data/models/get_vaccine_details_response_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_filters_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_services.dart';

class VaccineViewRepo {
  final VaccineApiServices vaccineApiServices;

  VaccineViewRepo(this.vaccineApiServices);

  Future<ApiResult<List<String>>> fetchUserSubmissionDates() async {
    try {
      final response = await vaccineApiServices.getUserSubmissionDates();
      return ApiResult.success(List<String>.from(response["data"]));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetUserVaccinesResponseModel>> getUserVaccines({
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response =
          await vaccineApiServices.getUserVaccines(dateFrom, dateTo);
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

  /// Full record behind one row of the user's vaccines table.
  Future<ApiResult<VaccineUserEntryDetailsModel>> getVaccineUserEntryById(
      String id) async {
    try {
      final response = await vaccineApiServices.getVaccineUserEntryById(id);
      final details = response.vaccineDetails;

      return ApiResult.success(details!);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  /// Deletes one of the user's vaccine entries. Returns the API's own message.
  Future<ApiResult<String>> deleteVaccineUserEntry(String id) async {
    try {
      final response = await vaccineApiServices.deleteVaccineUserEntry(id);
      return ApiResult.success(response["message"] as String);
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
          await vaccineApiServices.deleteVaccine(language, vaccineId, userType);
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
