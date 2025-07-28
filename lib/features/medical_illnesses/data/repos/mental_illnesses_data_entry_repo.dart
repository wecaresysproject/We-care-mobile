import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_services.dart';

class MentalIllnessesDataEntryRepo {
  final MentalIllnessesServices _illnessesServices;

  MentalIllnessesDataEntryRepo(
      {required MentalIllnessesServices illnessesServices})
      : _illnessesServices = illnessesServices;

  Future<ApiResult<List<String>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getCountries(language);
      final countriesNames = (response['data'] as List)
          .map((e) => CountryModel.fromJson(e).name)
          .toList();
      return ApiResult.success(countriesNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMentalIllnessTypes(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getMentalIllnessTypes(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedicalSyptoms(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getMedicalSyptoms(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getIncidentTypes(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getIncidentTypes(language);
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedicationImpactOnDailyLife(
      {required String language}) async {
    try {
      final response =
          await _illnessesServices.getMedicationImpactOnDailyLife(language);
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getPsychologicalEmergencies(
      {required String language}) async {
    try {
      final response =
          await _illnessesServices.getPsychologicalEmergencies(language);
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedicationSideEffects(
      {required String language}) async {
    try {
      final response =
          await _illnessesServices.getMedicationSideEffects(language);
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>>
      getPreferredActivitiesForPsychologicalImprovement(
          {required String language}) async {
    try {
      final response = await _illnessesServices
          .getPreferredActivitiesForPsychologicalImprovement(language);
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postMentalIlnessDataEntryEndPoint({
    required String language,
    required String userType,
    required MentalIllnessRequestBody requestBody,
  }) async {
    try {
      final response =
          await _illnessesServices.postMentalIlnessDataEntryEndPoint(
        language,
        userType,
        requestBody,
      );

      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editMentalIllnessDataEntered({
    required String id,
    required String language,
    required MentalIllnessRequestBody requestBody,
  }) async {
    try {
      final response = await _illnessesServices.editMentalIllnessDataEntered(
        language,
        id,
        UserTypes.patient.name.firstLetterToUpperCase,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
