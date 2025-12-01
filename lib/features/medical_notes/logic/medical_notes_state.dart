part of 'medical_notes_cubit.dart';

class MedicalNotesState extends Equatable {
  final List<MedicalNote> notes;
  final List<MedicalNote> filteredNotes;
  final bool isSelectionMode;
  final RequestStatus requestStatus;
  final String? errorMessage;
  final String searchQuery;

  const MedicalNotesState({
    required this.notes,
    required this.filteredNotes,
    required this.isSelectionMode,
    required this.requestStatus,
    this.errorMessage,
    required this.searchQuery,
  });

  factory MedicalNotesState.initial() {
    return const MedicalNotesState(
      notes: [],
      filteredNotes: [],
      isSelectionMode: false,
      requestStatus: RequestStatus.initial,
      errorMessage: null,
      searchQuery: '',
    );
  }

  MedicalNotesState copyWith({
    List<MedicalNote>? notes,
    List<MedicalNote>? filteredNotes,
    bool? isSelectionMode,
    RequestStatus? requestStatus,
    String? errorMessage,
    String? searchQuery,
  }) {
    return MedicalNotesState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      requestStatus: requestStatus ?? this.requestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Helper getters
  List<MedicalNote> get selectedNotes =>
      filteredNotes.where((note) => note.isSelected).toList();

  int get selectedCount => selectedNotes.length;

  bool get hasSelectedNotes => selectedCount > 0;

  @override
  List<Object?> get props => [
        notes,
        filteredNotes,
        isSelectionMode,
        requestStatus,
        errorMessage,
        searchQuery,
      ];
}
