import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/research_and_papers/data/models/research_papers_request_body_model.dart';
import 'package:we_care/features/doctor/research_and_papers/data/repos/research_and_papers_repo.dart';
import 'package:we_care/features/doctor/research_and_papers/logic/cubit/research_paper_form_entry.dart';

part 'research_and_papers_state.dart';

class ResearchAndPapersCubit extends Cubit<ResearchAndPapersState>
    with SafeEmitMixin<ResearchAndPapersState> {
  ResearchAndPapersCubit(this._researchAndPapersRepo)
      : super(ResearchAndPapersState.initial());

  final ResearchAndPapersRepo _researchAndPapersRepo;

  final formKey = GlobalKey<FormState>();

  void addResearchPaper() {
    safeEmit(
      state.copyWith(entries: [...state.entries, ResearchPaperFormEntry()]),
    );
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
  }

  Future<void> submitResearchPapers() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = ResearchPapersRequestBodyModel(
      researchPapers: state.entries.map((entry) => entry.toModel()).toList(),
    );

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
