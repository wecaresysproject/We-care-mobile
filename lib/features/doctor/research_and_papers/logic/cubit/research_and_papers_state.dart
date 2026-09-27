part of 'research_and_papers_cubit.dart';

class ResearchAndPapersState extends Equatable {
  const ResearchAndPapersState({
    required this.entries,
    required this.submissionStatus,
    required this.message,
  });

  factory ResearchAndPapersState.initial() => ResearchAndPapersState(
        entries: [ResearchPaperFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<ResearchPaperFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  ResearchAndPapersState copyWith({
    List<ResearchPaperFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return ResearchAndPapersState(
      entries: entries ?? this.entries,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [entries, submissionStatus, message];
}
