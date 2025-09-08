import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/allergy/allergy_services.dart';
import 'package:we_care/features/allergy/data/models/allergy_details_data_model.dart';
import 'package:we_care/features/allergy/data/models/allergy_disease_model.dart';
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

  Future<ApiResult<List<AllergyDiseaseModel>>> getAllergyDiseases(
      {required String language, int? page, int? pageSize}) async {
    try {
      final response = await allergyServices.getAllergyDiseases(
        language,
        'Patient',
        page ?? 1,
        pageSize ?? 10,
      );
      final List<AllergyDiseaseModel> diseases = (response['data'] as List)
          .map((e) => AllergyDiseaseModel.fromJson(e))
          .toList();
      return ApiResult.success(diseases);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AllergyDetailsData>> getSingleAllergyDetailsById({
    required String id,
    required String language,
  }) async {
    try {
      final response = await allergyServices.getSingleAllergyDetailsById(
        id,
        language,
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      return ApiResult.success(
        AllergyDetailsData.fromJson(
          response['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteAllergyById({
    required String id,
    required String language,
  }) async {
    try {
      final response = await allergyServices.deleteAllergyById(
        id,
        language,
        UserTypes.patient.name.firstLetterToUpperCase,
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
