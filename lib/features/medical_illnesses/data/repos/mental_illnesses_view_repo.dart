import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_services.dart';

class MentalIllnessesViewRepo {
  final MentalIllnessesServices mentalIllnessesServices;

  MentalIllnessesViewRepo({required this.mentalIllnessesServices});

  // /// Get all available years to filter Eye Part Procedures & Symptoms Documents
  // Future<ApiResult<List<String>>> getAvailableEyePartDocumentYears({
  //   required String language,
  //   required String userType,
  //   required String affectedEyePart,
  // }) async {
  //   try {
  //     final response = await eyesService.getAvailableYears(
  //       language,
  //       userType,
  //       affectedEyePart,
  //     );
  //     final List<String> years = List<String>.from(response['data']);
  //     return ApiResult.success(years);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Get paginated Eye Part Procedures & Symptoms Documents
  // Future<ApiResult<UserProceduresAndSymptoms>>
  //     getEyePartProceduresAndSymptomsDocuments({
  //   required int page,
  //   required int limit,
  //   required String affectedEyePart,
  // }) async {
  //   try {
  //     final response = await eyesService.getAllDocuments(
  //       page: page,
  //       limit: limit,
  //       language: 'en',
  //       userType: UserTypes.patient.name.firstLetterToUpperCase,
  //       affectedEyePart: affectedEyePart,
  //     );
  //     return ApiResult.success(UserProceduresAndSymptoms.fromJson(response));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Get filtered Eye Part Procedures & Symptoms Documents
  // Future<ApiResult<UserProceduresAndSymptoms>>
  //     getFilteredEyePartProceduresAndSymptomsDocuments(
  //         {String? year,
  //         String? category,
  //         required String affectedEyePart}) async {
  //   try {
  //     final response = await eyesService.getFilteredDocuments(
  //       year,
  //       category,
  //       'ar',
  //       UserTypes.patient.name.firstLetterToUpperCase,
  //       affectedEyePart,
  //     );
  //     return ApiResult.success(UserProceduresAndSymptoms.fromJson(response));
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Get full details of Eye Part Document by ID
  // Future<ApiResult<EyeProceduresAndSymptomsDetailsModel>>
  //     getEyePartDocumentDetailsById({
  //   required String id,
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response = await eyesService.getDocumentDetailsById(
  //       id,
  //       language,
  //       userType,
  //     );
  //     return ApiResult.success(
  //       EyeProceduresAndSymptomsDetailsModel.fromJson(response['data']),
  //     );
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Delete Eye Part Document by ID
  // Future<ApiResult<String>> deleteEyePartDocumentById({
  //   required String id,
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response = await eyesService.deleteDocumentById(
  //       id,
  //       language,
  //       userType,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Get paginated Eye Glasses Records
  // Future<ApiResult<List<EyeGlassesRecordModel>>> getEyeGlassesRecords({
  //   required int page,
  //   required int limit,
  // }) async {
  //   try {
  //     final response = await eyesService.getAllGlasses(
  //       language: 'ar',
  //       userType: UserTypes.patient.name.firstLetterToUpperCase,
  //       page: page,
  //       limit: limit,
  //     );
  //     log('Eye Glasses Records Response: $response[data]');
  //     final List<dynamic>? rawList = response['data'];

  //     return ApiResult.success(
  //       rawList?.map((e) => EyeGlassesRecordModel.fromJson(e)).toList() ?? [],
  //     );
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Get full details of Eye Glasses Record by ID
  // Future<ApiResult<EyeGlassesDetailsModel>> getEyeGlassesDetailsById({
  //   required String id,
  // }) async {
  //   try {
  //     final response = await eyesService.getGlassesDetailsById(
  //       id,
  //       'ar',
  //       UserTypes.patient.name.firstLetterToUpperCase,
  //     );
  //     log('Eye Glasses Details Response: $response[data]');
  //     return ApiResult.success(
  //       EyeGlassesDetailsModel.fromJson(response['data']),
  //     );
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // /// Delete Eye Glasses Record by ID
  // Future<ApiResult<String>> deleteEyeGlassesRecordById({
  //   required String id,
  // }) async {
  //   try {
  //     final response = await eyesService.deleteGlassesById(
  //       id,
  //       'ar',
  //       UserTypes.patient.name.firstLetterToUpperCase,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
  Future<ApiResult<bool>> getIsUmbrellaMentalIllnessButtonActivated() async {
    try {
      final response = await mentalIllnessesServices
          .getIsUmbrellaMentalIllnessButtonActivated();
      return ApiResult.success(
          response['isMedicalIlnessUmbrellaButtonActivated']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedicalIllnessDocsAvailableYears(

      // {
      // required String language,
      // required String userType,
      // }

      ) async {
    try {
      final response =
          await mentalIllnessesServices.getMedicalIllnessDocsAvailableYears();
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
}
