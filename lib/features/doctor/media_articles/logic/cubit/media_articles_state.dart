part of 'media_articles_cubit.dart';

class MediaArticlesState extends Equatable {
  const MediaArticlesState({
    required this.entries,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory MediaArticlesState.initial() => MediaArticlesState(
        entries: [MediaArticleFormEntry()],
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<MediaArticleFormEntry> entries;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved media and articles. The form shows only on success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved media and articles before, so the form opened
  /// pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  MediaArticlesState copyWith({
    List<MediaArticleFormEntry>? entries,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return MediaArticlesState(
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
