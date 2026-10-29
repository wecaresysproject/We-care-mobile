import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/awards/data/models/awards_request_body_model.dart';
import 'package:we_care/features/doctor/awards/data/repos/awards_repo.dart';
import 'package:we_care/features/doctor/awards/logic/cubit/award_form_entry.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'awards_state.dart';

class AwardsCubit extends Cubit<AwardsState> with SafeEmitMixin<AwardsState> {
  AwardsCubit(this._sharedRepo, this._awardsRepo)
      : super(AwardsState.initial());

  final AppSharedRepo _sharedRepo;
  final AwardsRepo _awardsRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  /// Loads the dropdown options and the doctor's saved awards together.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await Future.wait([emitCountriesData(), _loadSavedAwards()]);
  }

  Future<void> _loadSavedAwards() async {
    final response = await _awardsRepo.getAwards();
    response.when(
      success: (awards) {
        if (awards.isEmpty) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        for (final entry in state.entries) {
          entry.dispose();
        }
        final entries = awards.map(AwardFormEntry.fromModel).toList();
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

  AwardsRequestBodyModel _buildRequestBody(List<AwardFormEntry> entries) =>
      AwardsRequestBodyModel(
        awards: entries.map((entry) => entry.toModel()).toList(),
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

  void addAward() {
    final entry = AwardFormEntry()..addTextListener(_updateHasChanges);
    safeEmit(state.copyWith(entries: [...state.entries, entry]));
    _updateHasChanges();
  }

  void removeAward(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(state.copyWith(
      entries: state.entries.where((entry) => entry.key != entryKey).toList(),
    ));
    _updateHasChanges();
  }

  void updateAwardCountry(Key entryKey, String? country) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedCountry = country;
    _touch();
  }

  /// [date] comes from the date picker as `yyyy-MM-dd`; only the year is kept.
  void updateAwardYear(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedYear = DateTime.parse(date).year.toString();
    _touch();
  }

  void _touch() {
    safeEmit(state.copyWith(entries: [...state.entries]));
    _updateHasChanges();
  }

  Future<void> submitAwards() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.entries);

    final response = await _awardsRepo.submitAwards(model);
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
