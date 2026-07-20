part of 'medical_notes_cubit.dart';

class MedicalNotesState extends Equatable {
  final List<MedicalNote> notes;
  final List<MedicalNote> filteredNotes;
  final bool isSelectionMode;
  final RequestStatus requestStatus;
  final RequestStatus moduleGuuidanceRequestStatus;
  final String? message;
  final String searchQuery;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const MedicalNotesState({
    required this.notes,
    required this.filteredNotes,
    required this.isSelectionMode,
    required this.requestStatus,
    required this.moduleGuuidanceRequestStatus,
    this.message,
    required this.searchQuery,
    this.moduleGuidanceData,
  });

  factory MedicalNotesState.initial() {
    return const MedicalNotesState(
      notes: [],
      filteredNotes: [],
      isSelectionMode: false,
      requestStatus: RequestStatus.initial,
      moduleGuuidanceRequestStatus: RequestStatus.initial,
      message: null,
      searchQuery: '',
      moduleGuidanceData: null,
    );
  }

  MedicalNotesState copyWith({
    List<MedicalNote>? notes,
    List<MedicalNote>? filteredNotes,
    bool? isSelectionMode,
    RequestStatus? requestStatus,
    RequestStatus? moduleGuuidanceRequestStatus,
    String? message,
    String? searchQuery,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return MedicalNotesState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      requestStatus: requestStatus ?? this.requestStatus,
      moduleGuuidanceRequestStatus:
          moduleGuuidanceRequestStatus ?? this.moduleGuuidanceRequestStatus,
      message: message ?? this.message,
      searchQuery: searchQuery ?? this.searchQuery,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

//
  // Helper getters
  List<MedicalNote> get selectedNotes =>
      filteredNotes.where((note) => note.isSelected!).toList();

  int get selectedCount => selectedNotes.length;

  bool get hasSelectedNotes => selectedCount > 0;

  @override
  List<Object?> get props => [
        notes,
        filteredNotes,
        isSelectionMode,
        requestStatus,
        moduleGuuidanceRequestStatus,
        message,
        searchQuery,
        moduleGuidanceData,
      ];
}
