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

part 'awards_state.dart';

class AwardsCubit extends Cubit<AwardsState> with SafeEmitMixin<AwardsState> {
  AwardsCubit(this._sharedRepo, this._awardsRepo)
      : super(AwardsState.initial());

  final AppSharedRepo _sharedRepo;
  final AwardsRepo _awardsRepo;

  final formKey = GlobalKey<FormState>();

  Future<void> loadInitialData() async {
    await emitCountriesData();
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
    safeEmit(state.copyWith(
      entries: [...state.entries, AwardFormEntry()],
    ));
  }

  void removeAward(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(state.copyWith(
      entries: state.entries.where((entry) => entry.key != entryKey).toList(),
    ));
  }

  void updateAwardCountry(Key entryKey, String? country) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedCountry = country;
    _touch();
  }

  void _touch() {
    safeEmit(state.copyWith(entries: [...state.entries]));
  }

  Future<void> submitAwards() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = AwardsRequestBodyModel(
      awards: state.entries.map((entry) => entry.toModel()).toList(),
    );

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
