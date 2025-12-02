import 'package:uuid/uuid.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medical_notes/data/models/medical_note_model.dart';

class MedicalNotesRepository {
  // In-memory storage for now - will be replaced with API calls later
  final List<MedicalNote> _notes = [];
  final Uuid _uuid = const Uuid();

  MedicalNotesRepository() {
    // Add some dummy data for testing
    _notes.addAll([
      MedicalNote(
        id: _uuid.v4(),
        date: DateTime(2025, 5, 12),
        content: 'راجع احدث نتائج تحليل الدم للمريض.',
      ),
      MedicalNote(
        id: _uuid.v4(),
        date: DateTime(2025, 1, 12),
        content: 'حدد موعد متابعة مع المريض ............',
      ),
      MedicalNote(
        id: _uuid.v4(),
        date: DateTime(2024, 12, 12),
        content: 'حدد موعد متابعة مع المريض ............',
      ),
      MedicalNote(
        id: _uuid.v4(),
        date: DateTime(2024, 10, 20),
        content: 'حدد موعد متابعة مع المريض ............',
      ),
      MedicalNote(
        id: _uuid.v4(),
        date: DateTime(2024, 8, 12),
        content: 'حدد موعد متابعة مع المريض ............',
      ),
    ]);
  }

  Future<ApiResult<List<MedicalNote>>> getAllNotes() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Sort by date descending (newest first)
      final sortedNotes = List<MedicalNote>.from(_notes)
        ..sort((a, b) => b.date.compareTo(a.date));

      return ApiResult.success(sortedNotes);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalNote>> createNote(String content) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final newNote = MedicalNote(
        id: _uuid.v4(),
        date: DateTime.now(),
        content: content,
      );

      _notes.add(newNote);

      return ApiResult.success(newNote);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicalNote>> updateNote(String id, String content) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _notes.indexWhere((note) => note.id == id);

      if (index == -1) {
        throw Exception('Note not found');
      }

      final updatedNote = _notes[index].copyWith(
        content: content,
        date: DateTime.now(), // Update the date when editing
      );

      _notes[index] = updatedNote;

      return ApiResult.success(updatedNote);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<void>> deleteNotes(List<String> ids) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      _notes.removeWhere((note) => ids.contains(note.id));

      return ApiResult.success(null);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<MedicalNote>>> searchNotes(String query) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      if (query.isEmpty) {
        return getAllNotes();
      }

      final filteredNotes = _notes
          .where((note) =>
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return ApiResult.success(filteredNotes);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
