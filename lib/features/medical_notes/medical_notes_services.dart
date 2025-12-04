import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/medical_notes/medical_note_api_constants.dart';

part 'medical_notes_services.g.dart';

@RestApi(baseUrl: MedicalNoteApiConstants.baseUrl)
abstract class MedicalNotesServices {
  factory MedicalNotesServices(Dio dio, {String baseUrl}) =
      _MedicalNotesServices;

  /// Get all medical notes for the user
  @GET(MedicalNoteApiConstants.getAllNotes)
  Future<dynamic> getAllNotes(
    @Query("language") String language,
    @Query("userType") String userType,
  );

  /// Create a new medical note
  @POST(MedicalNoteApiConstants.createNote)
  Future<dynamic> createNote(
    @Query("language") String language,
    @Query("userType") String userType,
    @Body() Map<String, dynamic> requestBody,
  );

  /// Update an existing medical note
  @PUT(MedicalNoteApiConstants.updateNote)
  Future<dynamic> updateNote(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
    @Body() Map<String, dynamic> requestBody,
  );

  /// Delete multiple medical notes
  @DELETE(MedicalNoteApiConstants.deleteNotes)
  Future<dynamic> deleteNotes(
    @Query("language") String language,
    @Query("userType") String userType,
    @Body() List<String> requestBody,
  );

  // /// Search medical notes by query
  // @GET(MedicalNoteApiConstants.searchNotes)
  // Future<dynamic> searchNotes(
  //   @Query("query") String query,
  //   @Query("language") String language,
  //   @Query("userType") String userType,
  //   @Query("page") int page,
  //   @Query("pageSize") int pageSize,
  // );
}
