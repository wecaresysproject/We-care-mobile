import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/membership/data/models/memberships_request_body_model.dart';
import 'package:we_care/features/doctor/membership/data/repos/membership_repo.dart';
import 'package:we_care/features/doctor/membership/logic/cubit/membership_form_entry.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'membership_state.dart';

class MembershipCubit extends Cubit<MembershipState>
    with SafeEmitMixin<MembershipState> {
  MembershipCubit(this._sharedRepo, this._membershipRepo)
      : super(MembershipState.initial());

  final AppSharedRepo _sharedRepo;
  final MembershipRepo _membershipRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  /// Loads the doctor's saved memberships and the dropdown options together.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await Future.wait([emitCountriesData(), _loadSavedMemberships()]);
  }

  Future<void> _loadSavedMemberships() async {
    final response = await _membershipRepo.getMemberships();
    response.when(
      success: (items) {
        if (items.isEmpty) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        for (final entry in state.entries) {
          entry.dispose();
        }
        final entries = items.map(MembershipFormEntry.fromModel).toList();
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

  MembershipsRequestBodyModel _buildRequestBody(
    List<MembershipFormEntry> entries,
  ) =>
      MembershipsRequestBodyModel(
        memberships: entries.map((entry) => entry.toModel()).toList(),
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

  void addMembership() {
    final entry = MembershipFormEntry()..addTextListener(_updateHasChanges);
    safeEmit(state.copyWith(entries: [...state.entries, entry]));
    _updateHasChanges();
  }

  void removeMembership(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(state.copyWith(
      entries: state.entries.where((entry) => entry.key != entryKey).toList(),
    ));
    _updateHasChanges();
  }

  void updateMembershipCountry(Key entryKey, String? country) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedCountry = country;
    _touch();
  }

  void updateMembershipLevel(Key entryKey, String? level) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedMembershipLevel = level;
    _touch();
  }

  /// [date] comes from the date picker as `yyyy-MM-dd`; only the year is kept.
  void updateMembershipYear(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedYear = DateTime.parse(date).year.toString();
    _touch();
  }

  void _touch() {
    safeEmit(state.copyWith(entries: [...state.entries]));
    _updateHasChanges();
  }

  Future<void> submitMemberships() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.entries);

    final response = await _membershipRepo.submitMemberships(model);
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
