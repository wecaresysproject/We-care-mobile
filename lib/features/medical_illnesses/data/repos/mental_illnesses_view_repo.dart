import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medical_illnesses/data/models/answered_question_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/follow_up_record_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/get_follow_up_report_section_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_request_body.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_umbrella_model.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_services.dart';

class MentalIllnessesViewRepo {
  final MentalIllnessesServices mentalIllnessesServices;

  MentalIllnessesViewRepo({required this.mentalIllnessesServices});

  Future<ApiResult<bool>> getIsUmbrellaMentalIllnessButtonActivated() async {
    try {
      final response = await mentalIllnessesServices.getActivationOfUmbrella(
        UserTypes.patient.name.firstLetterToUpperCase,
        'ar',
      );
      return ApiResult.success(response['data']['isActivated']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedicalIllnessDocsAvailableYears() async {
    try {
      final response =
          await mentalIllnessesServices.getMedicalIllnessDocsAvailableYears(
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      final List<String> years = List<String>.from(response['data']);
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<MentalIllnessModel>>> getMentalIllnessRecords({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await mentalIllnessesServices.getMentalIllnessRecords(
        language: 'ar',
        userType: UserTypes.patient.name.firstLetterToUpperCase,
        page: page,
        limit: limit,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList?.map((e) => MentalIllnessModel.fromJson(e)).toList() ?? [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<MentalIllnessModel>>> getFilteredMentalIllnessDocuments(
      {String? year}) async {
    try {
      final response =
          await mentalIllnessesServices.getFilteredMentalIllnessDocuments(
        year,
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList?.map((e) => MentalIllnessModel.fromJson(e)).toList() ?? [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MentalIllnessRequestBody>>
      getMentalIllnessDocumentDetailsById({
    required String id,
  }) async {
    try {
      final response =
          await mentalIllnessesServices.getMentalIllnessDocumentDetailsById(
        id,
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      return ApiResult.success(
        MentalIllnessRequestBody.fromJson(response['data']),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteMentalIllnessDetailsDocumentById({
    required String id,
  }) async {
    try {
      final response =
          await mentalIllnessesServices.deleteMentalIllnessDetailsDocumentById(
        id,
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<MentalIllnessUmbrellaModel>>>
      getMedicalIllnessUmbrellaDocs({
    required int page,
    required int limit,
  }) async {
    try {
      final response =
          await mentalIllnessesServices.getMedicalIllnessUmbrellaDocs(
        language: 'ar',
        userType: UserTypes.patient.name.firstLetterToUpperCase,
        page: page,
        limit: limit,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList?.map((e) => MentalIllnessUmbrellaModel.fromJson(e)).toList() ??
            [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<AnsweredQuestionModel>>>
      getAllAnsweredQuestions() async {
    try {
      final response = await mentalIllnessesServices.getAllAnsweredQuestions(
        language: 'ar',
        userType: UserTypes.patient.name.firstLetterToUpperCase,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList?.map((e) => AnsweredQuestionModel.fromJson(e)).toList() ?? [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getFollowUpReportsAvailableYears() async {
    try {
      final response =
          await mentalIllnessesServices.getFollowUpReportsAvailableYears(
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      final List<String> years = List<String>.from(response['data']);
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<FollowUpRecordModel>>> getAllFollowUpReportsRecords({
    required int page,
    required int limit,
  }) async {
    try {
      final response =
          await mentalIllnessesServices.getAllFollowUpReportsRecords(
        language: 'ar',
        userType: UserTypes.patient.name.firstLetterToUpperCase,
        page: page,
        limit: limit,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList?.map((e) => FollowUpRecordModel.fromJson(e)).toList() ?? [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<FollowUpRecordModel>>> getFilteredFollowUpReports({
    String? year,
  }) async {
    try {
      final response = await mentalIllnessesServices.getFilteredFollowUpReports(
        year,
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList?.map((e) => FollowUpRecordModel.fromJson(e)).toList() ?? [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<GetFollowUpReportSectionModel>>>
      getFollowUpDocumentDetailsById({
    required String id,
  }) async {
    try {
      final response =
          await mentalIllnessesServices.getFollowUpDocumentDetailsById(
        id,
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      final List<dynamic>? rawList = response['data'];

      return ApiResult.success(
        rawList
                ?.map((e) => GetFollowUpReportSectionModel.fromJson(e))
                .toList() ??
            [],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
