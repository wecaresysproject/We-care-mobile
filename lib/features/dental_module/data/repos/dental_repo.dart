import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/dental_filters_response_model.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_documents_reponse_model.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_operation_details_by_id.dart';
import 'package:we_care/features/dental_module/dental_services.dart';

class DentalRepo {
  final DentalService dentalService;
  DentalRepo({required this.dentalService});

  Future<ApiResult<List<int>>> getDefectedTooth(
      {required String userType, required String language}) async {
    try {
      final response = await dentalService.getDefectedTooth(userType, language);

      return ApiResult.success(
        (response['data'] as List).map((e) => int.parse(e)).toList(),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetToothDocumentsResponseModel>> getDocumentsByToothNumber({
    required String toothNumber,
    required String userType,
    required String language,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await dentalService.getDocumentsByToothNumber(
        toothNumber,
        userType,
        language,
        page,
        pageSize,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<ToothOperationDetails>> getToothOperationDetailsById({
    required String id,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await dentalService.getToothOperationDetailsById(
          id, userType, language);
      return ApiResult.success(ToothOperationDetails.fromJson(
          response['data'] as Map<String, dynamic>));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  //delete tooth operation details by id
  Future<ApiResult<String>> deleteToothOperationDetailsById({
    required String id,
    required String userType,
    required String language,
  }) async {
    try {
      final response = await dentalService.deleteToothOperationDetailsById(
          id, userType, language);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DentalFilterResponseModel>> getToothFilters({
    required String userType,
    required String language,
  }) async {
    try {
      final response = await dentalService.getToothFilters(userType, language);
      return ApiResult.success(
          DentalFilterResponseModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<int>>> getFilteredToothDocuments({
    required String userType,
    required String language,
    int? year,
    String? toothNumber,
    String? procedureType,
  }) async {
    try {
      final response =
          await dentalService.getFilteredToothDocuments(
        userType,
        language,
        toothNumber,
        year,
        procedureType,
      );
      return ApiResult.success(
      response['data'] != null
          ? (response['data'] as List).map((e) => int.parse(e)).toList()
          : <int>[],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }


  // Future<ApiResult<GetSurgeriesFiltersResponseModel>> gettFilters(
  //     {required String language}) async {
  //   try {
  //     final response = await surgeriesService.getFilters(language);
  //     return ApiResult.success(
  //         GetSurgeriesFiltersResponseModel.fromJson(response['data']));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<GetUserSurgeriesResponseModal>> getUserSurgeriesList(
  //     {required String language, int? page, int? pageSize}) async {
  //   try {
  //     final response = await surgeriesService.getSurgeries(language,
  //         'Patient', page ?? 1, pageSize ?? 10);
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<SurgeryModel>> getSurgeryDetailsById({
  //   required String id,
  //   required String language,
  // }) async {
  //   try {
  //     final response = await surgeriesService.getSurgeryById(id, language);
  //     return ApiResult.success(SurgeryModel.fromJson(
  //         response['data'].first as Map<String, dynamic>));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> deleteSurgeryById({
  //   required String id,
  // }) async {
  //   try {
  //     final response = await surgeriesService.deleteSurgeryById(
  //       id,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<GetUserSurgeriesResponseModal>> getFilteredSurgeries({
  //   required String language,
  //   int? year,
  //   String? surgeryName,
  // }) async {
  //   try {
  //     final response = await surgeriesService.getFilteredSurgeries(
  //         language, surgeryName, year);

  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
