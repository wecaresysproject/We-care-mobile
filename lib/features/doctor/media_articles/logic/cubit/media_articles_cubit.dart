import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/media_articles/data/models/media_articles_request_body_model.dart';
import 'package:we_care/features/doctor/media_articles/data/repos/media_articles_repo.dart';
import 'package:we_care/features/doctor/media_articles/logic/cubit/media_article_form_entry.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'media_articles_state.dart';

class MediaArticlesCubit extends Cubit<MediaArticlesState>
    with SafeEmitMixin<MediaArticlesState> {
  MediaArticlesCubit(this._mediaArticlesRepo)
      : super(MediaArticlesState.initial());

  final MediaArticlesRepo _mediaArticlesRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  /// Loads the doctor's saved media and articles.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await _loadSavedMediaArticles();
  }

  Future<void> _loadSavedMediaArticles() async {
    final response = await _mediaArticlesRepo.getMediaArticles();
    response.when(
      success: (items) {
        if (items.isEmpty) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        for (final entry in state.entries) {
          entry.dispose();
        }
        final entries = items.map(MediaArticleFormEntry.fromModel).toList();
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

  MediaArticlesRequestBodyModel _buildRequestBody(
    List<MediaArticleFormEntry> entries,
  ) =>
      MediaArticlesRequestBodyModel(
        mediaArticles: entries.map((entry) => entry.toModel()).toList(),
      );

  void _updateHasChanges() {
    final hasChanges =
        _changesTracker.hasChanges(_buildRequestBody(state.entries).toJson());
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
  }

  void addMediaArticle() {
    final entry = MediaArticleFormEntry()..addTextListener(_updateHasChanges);
    safeEmit(state.copyWith(entries: [...state.entries, entry]));
    _updateHasChanges();
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
    _updateHasChanges();
  }

  Future<void> submitMediaArticles() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.entries);

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
