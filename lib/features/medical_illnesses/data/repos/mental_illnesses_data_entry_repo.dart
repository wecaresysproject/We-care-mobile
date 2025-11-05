import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/activate_umbrella_response_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/data/models/post_fcm_token_request_model.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_services.dart';

class MentalIllnessesDataEntryRepo {
  final MentalIllnessesServices _illnessesServices;
  final SharedServices _sharedServices;

  MentalIllnessesDataEntryRepo(
      {required MentalIllnessesServices illnessesServices,
      required SharedServices sharedServices})
      : _illnessesServices = illnessesServices,
        _sharedServices = sharedServices;

  Future<ApiResult<List<String>>> getCountriesData({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getCountriesNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final countries = (response['data'] as List)
          .map((country) => country as String)
          .toList();
      return ApiResult.success(countries);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getHospitalNames({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getHospitalNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final hospitals = (response['data'] as List)
          .map((hospital) => hospital as String)
          .toList();
      return ApiResult.success(hospitals);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllDoctors({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _sharedServices.getDoctorNames(
        userType,
        language,
      );
      final doctors = (response['data'] as List)
          .map<Doctor>((e) => Doctor.fromJson(e))
          .toList();
      final doctorNames = doctors.map((e) => e.fullName).toList();
      return ApiResult.success(doctorNames);
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

  Future<ApiResult<List<String>>> getIncidentTypes(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getIncidentTypes(
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

  Future<ApiResult<List<String>>> getMedicationImpactOnDailyLife(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getMedicationImpactOnDailyLife(
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

  Future<ApiResult<List<String>>> getPsychologicalEmergencies(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getPsychologicalEmergencies(
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

  Future<ApiResult<List<String>>> getMedicationSideEffects(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getMedicationSideEffects(
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

  Future<ApiResult<List<String>>>
      getPreferredActivitiesForPsychologicalImprovement(
          {required String language}) async {
    try {
      final response = await _illnessesServices
          .getPreferredActivitiesForPsychologicalImprovement(
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

  Future<ApiResult<String>> postMentalIlnessDataEntryEndPoint({
    required String language,
    required MentalIllnessRequestBody requestBody,
  }) async {
    try {
      final response =
          await _illnessesServices.postMentalIlnessDataEntryEndPoint(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
        requestBody,
      );

      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> sendQuestionareAnswers({
    required String language,
    required List<FcmQuestionModel> questions,
  }) async {
    try {
      final response = await _illnessesServices.postQuestionnaireAnswers(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
        questions,
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
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
        id,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postActivationOfUmbrella({
    required String language,
    required PostFcmTokenRequest requestBody,
  }) async {
    try {
      final response = await _illnessesServices.postActivationOfUmbrella(
        UserTypes.patient.name.firstLetterToUpperCase,
        'ar',
        requestBody,
      );

      return ApiResult.success(
        response['data']['message'],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<ActivateUmbrellaResponse>> getActivationStatusOfUmbrella({
    required String language,
  }) async {
    try {
      final response = await _illnessesServices.getActivationOfUmbrella(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );

      return ApiResult.success(
          ActivateUmbrellaResponse.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
