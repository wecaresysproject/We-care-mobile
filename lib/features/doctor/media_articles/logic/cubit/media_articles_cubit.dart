import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/media_articles/data/models/media_articles_request_body_model.dart';
import 'package:we_care/features/doctor/media_articles/data/repos/media_articles_repo.dart';
import 'package:we_care/features/doctor/media_articles/logic/cubit/media_article_form_entry.dart';

part 'media_articles_state.dart';

class MediaArticlesCubit extends Cubit<MediaArticlesState>
    with SafeEmitMixin<MediaArticlesState> {
  MediaArticlesCubit(this._mediaArticlesRepo)
      : super(MediaArticlesState.initial());

  final MediaArticlesRepo _mediaArticlesRepo;

  final formKey = GlobalKey<FormState>();

  void addMediaArticle() {
    safeEmit(
      state.copyWith(entries: [...state.entries, MediaArticleFormEntry()]),
    );
  }

  void removeMediaArticle(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(
      state.copyWith(
        entries: state.entries.where((entry) => entry.key != entryKey).toList(),
      ),
    );
  }

  Future<void> submitMediaArticles() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = MediaArticlesRequestBodyModel(
      mediaArticles: state.entries.map((entry) => entry.toModel()).toList(),
    );

    final response = await _mediaArticlesRepo.submitMediaArticles(model);
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
