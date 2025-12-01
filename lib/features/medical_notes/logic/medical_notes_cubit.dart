import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/medical_notes/data/models/medical_note_model.dart';
import 'package:we_care/features/medical_notes/data/repos/medical_notes_repository.dart';

part 'medical_notes_state.dart';

class MedicalNotesCubit extends Cubit<MedicalNotesState> {
  final MedicalNotesRepository repository;

  MedicalNotesCubit(this.repository) : super(MedicalNotesState.initial());

  /// Load all notes from repository
  Future<void> loadNotes() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await repository.getAllNotes();

    response.when(
      success: (notes) {
        emit(state.copyWith(
          notes: notes,
          filteredNotes: notes,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info('Loaded ${notes.length} medical notes');
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to load notes',
        ));
        AppLogger.error('Failed to load medical notes: ${error.errors}');
      },
    );
  }

  /// Create a new note
  Future<bool> createNote(String content) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await repository.createNote(content);

    bool success = false;
    response.when(
      success: (newNote) {
        final updatedNotes = List<MedicalNote>.from(state.notes)..add(newNote);
        emit(state.copyWith(
          notes: updatedNotes,
          filteredNotes: updatedNotes,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info('Created new medical note: ${newNote.id}');
        success = true;
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to create note',
        ));
        AppLogger.error('Failed to create medical note: ${error.errors}');
      },
    );

    return success;
  }

  /// Update an existing note
  Future<bool> updateNote(String id, String content) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await repository.updateNote(id, content);

    bool success = false;
    response.when(
      success: (updatedNote) {
        final updatedNotes = state.notes.map((note) {
          return note.id == id ? updatedNote : note;
        }).toList();

        final updatedFilteredNotes = state.filteredNotes.map((note) {
          return note.id == id ? updatedNote : note;
        }).toList();

        emit(state.copyWith(
          notes: updatedNotes,
          filteredNotes: updatedFilteredNotes,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info('Updated medical note: $id');
        success = true;
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to update note',
        ));
        AppLogger.error('Failed to update medical note: ${error.errors}');
      },
    );

    return success;
  }

  /// Delete selected notes
  Future<void> deleteSelectedNotes() async {
    final selectedIds = state.selectedNotes.map((note) => note.id).toList();

    if (selectedIds.isEmpty) return;

    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await repository.deleteNotes(selectedIds);

    response.when(
      success: (_) {
        final updatedNotes = state.notes
            .where((note) => !selectedIds.contains(note.id))
            .toList();

        final updatedFilteredNotes = state.filteredNotes
            .where((note) => !selectedIds.contains(note.id))
            .toList();

        emit(state.copyWith(
          notes: updatedNotes,
          filteredNotes: updatedFilteredNotes,
          isSelectionMode: false,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info('Deleted ${selectedIds.length} medical notes');
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to delete notes',
        ));
        AppLogger.error('Failed to delete medical notes: ${error.errors}');
      },
    );
  }

  /// Toggle selection mode
  void toggleSelectionMode(bool enabled) {
    if (!enabled) {
      // Clear all selections when exiting selection mode
      final clearedNotes = state.filteredNotes.map((note) {
        return note.copyWith(isSelected: false);
      }).toList();

      emit(state.copyWith(
        filteredNotes: clearedNotes,
        isSelectionMode: false,
      ));
    } else {
      emit(state.copyWith(isSelectionMode: true));
    }
  }

  /// Toggle a single note's selection
  void toggleNoteSelection(String noteId) {
    final updatedFilteredNotes = state.filteredNotes.map((note) {
      if (note.id == noteId) {
        return note.copyWith(isSelected: !note.isSelected);
      }
      return note;
    }).toList();

    emit(state.copyWith(filteredNotes: updatedFilteredNotes));
  }

  /// Search/filter notes
  Future<void> searchNotes(String query) async {
    emit(state.copyWith(
      searchQuery: query,
      requestStatus: RequestStatus.loading,
    ));

    final response = await repository.searchNotes(query);

    response.when(
      success: (filteredNotes) {
        emit(state.copyWith(
          filteredNotes: filteredNotes,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info(
            'Search returned ${filteredNotes.length} notes for query: "$query"');
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to search notes',
        ));
        AppLogger.error('Failed to search medical notes: ${error.errors}');
      },
    );
  }

  void shareSelectedNotes() {
    final selectedNotes = state.selectedNotes;

//share using share_plus
    Share.share(
        'Selected notes: ${selectedNotes.map((note) => note.content).join('\n')}');
  }
}
