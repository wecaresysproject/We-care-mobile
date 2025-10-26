import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_filters_response_model.dart';
import 'package:we_care/features/x_ray/xray_services.dart';

class XRayViewRepo {
  final XRayApiServices xRayApiServices;

  XRayViewRepo(this.xRayApiServices);

  Future<ApiResult<UserRadiologyDataResponse>> getUserRadiologyData(
      {required String language, required String userType,
      int? page, int? pageSize}) async {
    try {
      final response =
          await xRayApiServices.getUserRadiologyData(language, userType,
              page: page ?? 1, pageSize: pageSize ?? 10);
      return ApiResult.success(UserRadiologyDataResponse.fromJson(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<RadiologyData>> getSpecificUserRadiologyDocument({
    required String id,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await xRayApiServices.getSpecificUserRadiologyDocument(
          id, language, userType);
      return ApiResult.success(RadiologyData.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<XRayFilterResponseModel>> gettFilters(
      {required String language}) async {
    try {
      final response = await xRayApiServices.gettFilters(language);
      return ApiResult.success(
          XRayFilterResponseModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UserRadiologyDataResponse>> getFilteredData({
    required String language,
    int? year,
    String? radioType,
    String? bodyPart,
  }) async {
    try {
      final response = await xRayApiServices.getFilteredData(
          language, year, radioType, bodyPart);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteRadiologyDocumentById({
    required String id,
    required String language,
  }) async {
    try {
      final response =
          await xRayApiServices.deleteRadiologyDocument(id, language);
      return ApiResult.success(response["message"]);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
