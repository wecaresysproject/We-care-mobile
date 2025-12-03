import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medical_notes/medical_notes_services.dart';

import '../models/medical_note_model.dart';

class MedicalNotesRepository {
  final MedicalNotesServices _medicalNotesServices;

  MedicalNotesRepository({required MedicalNotesServices medicalNotesServices})
      : _medicalNotesServices = medicalNotesServices;

  /// Get all medical notes
  Future<ApiResult<List<MedicalNote>>> getAllNotes() async {
    try {
      final response = await _medicalNotesServices.getAllNotes(
        "ar",
        UserTypes.patient.name.firstLetterToUpperCase,
      );

      final notes = (response['data'] as List)
          .map((json) => MedicalNote.fromJson(json))
          .toList();

      return ApiResult.success(notes);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Create a new medical note
  Future<ApiResult<MedicalNote>> createNote({
    required String content,
  }) async {
    try {
      final requestBody = {
        'note': content,
      };

      final response = await _medicalNotesServices.createNote(
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
        requestBody,
      );

      final note = MedicalNote.fromJson(response['data']);
      return ApiResult.success(note);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Update an existing medical note
  Future<ApiResult<MedicalNote>> updateNote({
    required String id,
    required String content,
  }) async {
    try {
      final requestBody = {
        'Note': content,
      };

      final response = await _medicalNotesServices.updateNote(
        id,
        'ar',
        UserTypes.patient.name.firstLetterToUpperCase,
        requestBody,
      );

      final note = MedicalNote.fromJson(
        response['data'],
      );
      return ApiResult.success(note);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Delete multiple medical notes
  Future<ApiResult<String>> deleteNotes({
    required List<String> ids,
    required String language,
  }) async {
    try {
      final response = await _medicalNotesServices.deleteNotes(
        language,
        UserTypes.patient.name.firstLetterToUpperCase,
        ids,
      );

      return ApiResult.success(response['message'] as String);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Search medical notes by query
  // Future<ApiResult<List<MedicalNote>>> searchNotes({
  //   required String query,
  //   required String language,
  //   int page = 1,
  //   int pageSize = 100,
  // }) async {
  //   try {
  //     if (query.isEmpty) {
  //       return getAllNotes(language: language, page: page, pageSize: pageSize);
  //     }

  //     final response = await _medicalNotesServices.searchNotes(
  //       query,
  //       language,
  //       UserTypes.patient.name.firstLetterToUpperCase,
  //       page,
  //       pageSize,
  //     );

  //     final notes = (response['data'] as List)
  //         .map((json) => MedicalNote.fromJson(json))
  //         .toList();

  //     // Sort by date descending (newest first)
  //     notes.sort((a, b) => b.date.compareTo(a.date));

  //     return ApiResult.success(notes);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
