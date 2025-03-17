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
