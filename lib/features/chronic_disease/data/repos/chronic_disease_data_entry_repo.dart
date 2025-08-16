import 'package:we_care/features/chronic_disease/chronic_disease_services.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class ChronicDiseaseDataEntryRepo {
  final ChronicDiseaseServices _services;

  ChronicDiseaseDataEntryRepo(this._services);

  Future<ApiResult<List<String>>> getChronicDiseasesNames({
    required String language,
  }) async {
    try {
      final response = await _services.getChronicDiseasesNames(language);
      final diseases =
          (response['data'] as List).map((e) => e as String).toList();

      return ApiResult.success(diseases);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postChronicDiseaseData({
    required PostChronicDiseaseModel requestBody,
    required String language,
  }) async {
    try {
      final response = await _services.postChronicDiseaseData(
        requestBody,
        language,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<String>> updatePrescriptionDocumentDetails({
  //   required PrescriptionRequestBodyModel requestBody,
  //   required String documentId,
  // }) async {
  //   try {
  //     final response = await _services.updatePrescriptionDocumentDetails(
  //       requestBody,
  //       requestBody.language,
  //       requestBody.userType,
  //       documentId,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
