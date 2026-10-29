import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/experience/data/models/experiences_request_body_model.dart';
import 'package:we_care/features/doctor/experience/data/repos/experience_repo.dart';
import 'package:we_care/features/doctor/experience/logic/cubit/experience_form_entry.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'experience_state.dart';

class ExperienceCubit extends Cubit<ExperienceState>
    with SafeEmitMixin<ExperienceState> {
  ExperienceCubit(this._sharedRepo, this._experienceRepo)
      : super(ExperienceState.initial());

  final AppSharedRepo _sharedRepo;
  final ExperienceRepo _experienceRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  /// Loads the doctor's saved experiences and the dropdown options together.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await Future.wait([emitCountriesData(), _loadSavedExperiences()]);
  }

  Future<void> _loadSavedExperiences() async {
    final response = await _experienceRepo.getExperiences();
    response.when(
      success: (items) {
        if (items.isEmpty) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        for (final entry in state.entries) {
          entry.dispose();
        }
        final entries = items.map(ExperienceFormEntry.fromModel).toList();
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

  ExperiencesRequestBodyModel _buildRequestBody(
    List<ExperienceFormEntry> entries,
  ) =>
      ExperiencesRequestBodyModel(
        experiences: entries.map((entry) => entry.toModel()).toList(),
      );

  void _updateHasChanges() {
    final hasChanges =
        _changesTracker.hasChanges(_buildRequestBody(state.entries).toJson());
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
  }

  Future<void> emitCountriesData() async {
    final response = await _sharedRepo.getCountriesData(
      language: AppStrings.arabicLang,
      userType: UserTypes.doctor.name.firstLetterToUpperCase,
    );
    response.when(
      success: (countries) =>
          safeEmit(state.copyWith(countriesNames: countries)),
      failure: (error) => safeEmit(state.copyWith(message: error.errors.first)),
    );
  }

  void addExperience() {
    final entry = ExperienceFormEntry()..addTextListener(_updateHasChanges);
    safeEmit(state.copyWith(entries: [...state.entries, entry]));
    _updateHasChanges();
  }

  void removeExperience(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(state.copyWith(
      entries: state.entries.where((entry) => entry.key != entryKey).toList(),
    ));
    _updateHasChanges();
  }

  void updateExperienceCountry(Key entryKey, String? country) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedCountry = country;
    _touch();
  }

  void updateExperienceFromDate(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.fromDate = date;
    _touch();
  }

  void updateExperienceToDate(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.toDate = date;
    _touch();
  }

  void _touch() {
    safeEmit(state.copyWith(entries: [...state.entries]));
    _updateHasChanges();
  }

  Future<void> submitExperiences() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.entries);

    final response = await _experienceRepo.submitExperiences(model);
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
