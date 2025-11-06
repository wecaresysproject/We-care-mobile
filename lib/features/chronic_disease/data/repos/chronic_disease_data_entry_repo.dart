import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
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

  Future<ApiResult<String>> updateChronicDiseaseDocDetailsById({
    required PostChronicDiseaseModel requestBody,
    required String documentId,
  }) async {
    try {
      final response = await _services.updateChronicDiseaseDocDetailsById(
        requestBody,
        AppStrings.arabicLang,
        UserTypes.patient.name.firstLetterToUpperCase,
        documentId,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
