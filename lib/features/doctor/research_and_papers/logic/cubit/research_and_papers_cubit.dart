import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_papers_request_body_model.dart';
import 'package:we_care/features/doctor/research_and_papers/data/repos/research_and_papers_repo.dart';
import 'package:we_care/features/doctor/research_and_papers/logic/cubit/research_paper_form_entry.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'research_and_papers_state.dart';

class ResearchAndPapersCubit extends Cubit<ResearchAndPapersState>
    with SafeEmitMixin<ResearchAndPapersState> {
  ResearchAndPapersCubit(this._researchAndPapersRepo)
      : super(ResearchAndPapersState.initial());

  final ResearchAndPapersRepo _researchAndPapersRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  /// Loads the doctor's saved research papers.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await _loadSavedResearchPapers();
  }

  Future<void> _loadSavedResearchPapers() async {
    final response = await _researchAndPapersRepo.getResearchPapers();
    response.when(
      success: (items) {
        if (items.isEmpty) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        for (final entry in state.entries) {
          entry.dispose();
        }
        final entries = items.map(ResearchPaperFormEntry.fromModel).toList();
        for (final entry in entries) {
          entry.addTextListener(_updateHasChanges);
        }
        _changesTracker.setBaseline(_buildRequestBody(entries).toJson());
        safeEmit(state.copyWith(
          entries: entries,
          loadStatus: RequestStatus.success,
          isEditMode: true,
          hasChanges: false,
        ));
      },
      failure: (error) => safeEmit(state.copyWith(
        loadStatus: RequestStatus.failure,
        message: error.errors.first,
      )),
    );
  }

  ResearchPapersRequestBodyModel _buildRequestBody(
    List<ResearchPaperFormEntry> entries,
  ) =>
      ResearchPapersRequestBodyModel(
        researchPapers: entries.map((entry) => entry.toModel()).toList(),
      );

  void _updateHasChanges() {
    final hasChanges =
        _changesTracker.hasChanges(_buildRequestBody(state.entries).toJson());
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
  }

  void addResearchPaper() {
    final entry = ResearchPaperFormEntry()..addTextListener(_updateHasChanges);
    safeEmit(state.copyWith(entries: [...state.entries, entry]));
    _updateHasChanges();
  }

  void removeResearchPaper(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(
      state.copyWith(
        entries: state.entries.where((entry) => entry.key != entryKey).toList(),
      ),
    );
    _updateHasChanges();
  }

  /// [date] comes from the date picker as `yyyy-MM-dd`; only the year is kept.
  void updateResearchPaperYear(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedYear = DateTime.parse(date).year.toString();
    _updateHasChanges();
  }

  Future<void> submitResearchPapers() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.entries);

    final response = await _researchAndPapersRepo.submitResearchPapers(model);
    response.when(
      success: (message) => safeEmit(
        state.copyWith(
          message: message,
          submissionStatus: RequestStatus.success,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          message: error.errors.first,
          submissionStatus: RequestStatus.failure,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    for (final entry in state.entries) {
      entry.dispose();
    }
    return super.close();
  }
}
