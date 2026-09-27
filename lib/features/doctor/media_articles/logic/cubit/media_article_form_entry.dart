import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/media_articles/data/models/media_article_model.dart';

/// One media/article card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers for its
/// fields. Held by [MediaArticlesCubit], not by the state class, mirroring
/// how [CertificatesCubit] keeps its `TextEditingController`s on the cubit
/// rather than in the (Equatable) state.
class MediaArticleFormEntry {
  MediaArticleFormEntry() : key = UniqueKey();

  final Key key;

  final titleController = TextEditingController();
  final subjectController = TextEditingController();
  final mediaLinkController = TextEditingController();

  MediaArticleModel toModel() => MediaArticleModel(
        title: titleController.text.trim(),
        subject: subjectController.text.trim(),
        mediaLink: mediaLinkController.text.trim(),
      );

  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    mediaLinkController.dispose();
  }
}
