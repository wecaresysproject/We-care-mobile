part of 'media_articles_cubit.dart';

class MediaArticlesState extends Equatable {
  const MediaArticlesState({
    required this.entries,
    required this.submissionStatus,
    required this.message,
  });

  factory MediaArticlesState.initial() => MediaArticlesState(
        entries: [MediaArticleFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<MediaArticleFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  MediaArticlesState copyWith({
    List<MediaArticleFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return MediaArticlesState(
      entries: entries ?? this.entries,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [entries, submissionStatus, message];
}
