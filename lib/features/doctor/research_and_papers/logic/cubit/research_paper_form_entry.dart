import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_paper_model.dart';

/// One research/paper card's editable state — a stable [key] so Flutter can
/// track each card across list rebuilds, plus the controllers for its
/// fields. Held by [ResearchAndPapersCubit], not by the state class,
/// mirroring `MediaArticleFormEntry`.
class ResearchPaperFormEntry {
  ResearchPaperFormEntry() : key = UniqueKey();

  final Key key;

  final titleController = TextEditingController();
  final yearController = TextEditingController();
  final doiOrLinkController = TextEditingController();

  ResearchPaperModel toModel() => ResearchPaperModel(
        title: titleController.text.trim(),
        year: yearController.text.trim(),
        doiOrLink: doiOrLinkController.text.trim(),
      );

  void dispose() {
    titleController.dispose();
    yearController.dispose();
    doiOrLinkController.dispose();
  }
}
