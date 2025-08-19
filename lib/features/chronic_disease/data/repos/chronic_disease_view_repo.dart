import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_services.dart';
import 'package:we_care/features/chronic_disease/data/models/chronic_disease_model.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';

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

//! handle at as all model to got message in order to show for user according to message
  Future<ApiResult<List<ChronicDiseaseModel>>> getAllChronicDiseasesDocuments(
      {required String language,
      required String userType,
      int? page,
      int? pageSize}) async {
    try {
      final response = await diseaseServices.getAllChronicDiseasesDocuments(
        language,
        userType,
        page: page,
        pageSize: pageSize,
      );
      final chronicDiseases = response['data']
          .map<ChronicDiseaseModel>((e) => ChronicDiseaseModel.fromJson(e))
          .toList();
      return ApiResult.success(chronicDiseases);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<PostChronicDiseaseModel>> getUserChronicDiseaseDetailsById(
      {required String id,
      required String language,
      required String userType}) async {
    try {
      final response = await diseaseServices.getUserChronicDiseaseDetailsById(
          id, language, userType);
      return ApiResult.success(
          PostChronicDiseaseModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteUserChronicDiseaseById({
    required String id,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await diseaseServices.deleteUserChronicDiseaseById(
          id, language, userType);
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
