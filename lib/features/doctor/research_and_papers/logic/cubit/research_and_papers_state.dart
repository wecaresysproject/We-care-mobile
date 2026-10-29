part of 'research_and_papers_cubit.dart';

class ResearchAndPapersState extends Equatable {
  const ResearchAndPapersState({
    required this.entries,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory ResearchAndPapersState.initial() => ResearchAndPapersState(
        entries: [ResearchPaperFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<ResearchPaperFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved research papers. The form shows only on success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved research papers before, so the form opened
  /// pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  ResearchAndPapersState copyWith({
    List<ResearchPaperFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return ResearchAndPapersState(
      entries: entries ?? this.entries,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      loadStatus: loadStatus ?? this.loadStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
        entries,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
