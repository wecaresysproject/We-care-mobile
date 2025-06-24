import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_details_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_record_model.dart';
import 'package:we_care/features/eyes/data/models/eye_procedures_and_symptoms_details_model.dart';
import 'package:we_care/features/eyes/data/models/get_user_procedures_and_symptoms_response_model.dart';
import 'package:we_care/features/eyes/eyes_services.dart';

class EyesViewRepo {
  final EyesModuleServices eyesService;

  EyesViewRepo({required this.eyesService});

  /// Get all available years to filter Eye Part Procedures & Symptoms Documents
  Future<ApiResult<List<String>>> getAvailableEyePartDocumentYears() async {
    try {
      final response = await eyesService.getAvailableYears();
      final List<String> years = List<String>.from(response['data']);
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Get paginated Eye Part Procedures & Symptoms Documents
  Future<ApiResult<UserProceduresAndSymptoms>> getEyePartProceduresAndSymptomsDocuments({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await eyesService.getAllDocuments(page: page, limit: limit);
      return ApiResult.success(UserProceduresAndSymptoms.fromJson(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Get filtered Eye Part Procedures & Symptoms Documents
  Future<ApiResult<UserProceduresAndSymptoms>> getFilteredEyePartProceduresAndSymptomsDocuments({
    String? year,
    String? category,
  }) async {
    try {
      final response = await eyesService.getFilteredDocuments(
        year: year,
        category: category,
      );
      return ApiResult.success(UserProceduresAndSymptoms.fromJson(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Get full details of Eye Part Document by ID
  Future<ApiResult<EyeProceduresAndSymptomsDetailsModel>> getEyePartDocumentDetailsById({
    required String id,
  }) async {
    try {
      final response = await eyesService.getDocumentDetailsById(id);
      return ApiResult.success(
        EyeProceduresAndSymptomsDetailsModel.fromJson(response['data']),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Delete Eye Part Document by ID
  Future<ApiResult<String>> deleteEyePartDocumentById({
    required String id,
  }) async {
    try {
      final response = await eyesService.deleteDocumentById(id);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Get paginated Eye Glasses Records
  Future<ApiResult<List<EyeGlassesRecordModel>>> getEyeGlassesRecords({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await eyesService.getAllGlasses(
        page: page,
        limit: limit,
      );
      return ApiResult.success(
        List<EyeGlassesRecordModel>.from(
          response['data'].map(
            (e) => EyeGlassesRecordModel.fromJson(e),
          ),
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Get full details of Eye Glasses Record by ID
  Future<ApiResult<EyeGlassesDetailsModel>> getEyeGlassesDetailsById({
    required String id,
  }) async {
    try {
      final response = await eyesService.getGlassesDetailsById(id);
      return ApiResult.success(EyeGlassesDetailsModel.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Delete Eye Glasses Record by ID
  Future<ApiResult<String>> deleteEyeGlassesRecordById({
    required String id,
  }) async {
    try {
      final response = await eyesService.deleteGlassesById(id);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
