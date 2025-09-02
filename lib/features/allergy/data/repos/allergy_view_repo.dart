import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/allergy/allergy_services.dart';
import 'package:we_care/features/surgeries/data/models/get_surgeries_filters_response_model.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';

class AllergyViewRepo {
  final AllergyServices allergyServices;
  AllergyViewRepo({required this.allergyServices});

  Future<ApiResult<GetSurgeriesFiltersResponseModel>> gettFilters(
      {required String language}) async {
    try {
      final response = await allergyServices.getFilters(language);
      return ApiResult.success(
          GetSurgeriesFiltersResponseModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetUserSurgeriesResponseModal>> getUserSurgeriesList(
      {required String language, int? page, int? pageSize}) async {
    try {
      final response = await allergyServices.getSurgeries(
          language, 'Patient', page ?? 1, pageSize ?? 10);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<SurgeryModel>> getSurgeryDetailsById({
    required String id,
    required String language,
  }) async {
    try {
      final response = await allergyServices.getSurgeryById(id, language);
      return ApiResult.success(SurgeryModel.fromJson(
          response['data'].first as Map<String, dynamic>));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteSurgeryById({
    required String id,
  }) async {
    try {
      final response = await allergyServices.deleteSurgeryById(
        id,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetUserSurgeriesResponseModal>> getFilteredSurgeries({
    required String language,
    int? year,
    String? surgeryName,
  }) async {
    try {
      final response = await allergyServices.getFilteredSurgeries(
          language, surgeryName, year);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
