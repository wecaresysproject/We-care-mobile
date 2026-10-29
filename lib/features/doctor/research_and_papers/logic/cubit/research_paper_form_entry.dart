import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_paper_model.dart';

/// One research/paper card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers for its
/// fields. Held by [ResearchAndPapersCubit], not by the state class,
/// mirroring `MediaArticleFormEntry`.
class ResearchPaperFormEntry {
  ResearchPaperFormEntry() : key = UniqueKey();

  /// An entry filled with a research paper loaded from the server.
  factory ResearchPaperFormEntry.fromModel(ResearchPaperModel model) {
    final entry = ResearchPaperFormEntry()
      ..selectedYear = model.year.isEmpty ? null : model.year;
    entry.titleController.text = model.title;
    entry.doiOrLinkController.text = model.doiOrLink;
    return entry;
  }

  final Key key;
  String? selectedYear;

  final titleController = TextEditingController();
  final doiOrLinkController = TextEditingController();

  ResearchPaperModel toModel() => ResearchPaperModel(
        title: titleController.text.trim(),
        year: selectedYear ?? '',
        doiOrLink: doiOrLinkController.text.trim(),
      );

  /// Calls [listener] whenever one of this entry's text fields changes.
  void addTextListener(VoidCallback listener) {
    titleController.addListener(listener);
    doiOrLinkController.addListener(listener);
  }

  void dispose() {
    titleController.dispose();
    doiOrLinkController.dispose();
  }
}
