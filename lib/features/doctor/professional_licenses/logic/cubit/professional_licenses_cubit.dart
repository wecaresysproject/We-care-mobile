import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/professional_licenses/data/models/licenses_request_body_model.dart';
import 'package:we_care/features/doctor/professional_licenses/data/repos/professional_licenses_repo.dart';
import 'package:we_care/features/doctor/professional_licenses/logic/cubit/license_form_entry.dart';

part 'professional_licenses_state.dart';

class ProfessionalLicensesCubit extends Cubit<ProfessionalLicensesState>
    with SafeEmitMixin<ProfessionalLicensesState> {
  ProfessionalLicensesCubit(this._sharedRepo, this._licensesRepo)
      : super(ProfessionalLicensesState.initial());

  final AppSharedRepo _sharedRepo;
  final ProfessionalLicensesRepo _licensesRepo;

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

  void addLicense() {
    safeEmit(state.copyWith(
      entries: [...state.entries, LicenseFormEntry()],
    ));
  }

  void removeLicense(Key entryKey) {
    if (state.entries.length <= 1) return;

    final removed = state.entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    safeEmit(state.copyWith(
      entries: state.entries.where((entry) => entry.key != entryKey).toList(),
    ));
  }

  void updateLicenseCountry(Key entryKey, String? country) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.selectedCountry = country;
    _touch();
  }

  void updateLicenseDate(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.licenseDate = date;
    _touch();
  }

  void updateLicenseExpiryDate(Key entryKey, String date) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.expiryDate = date;
    _touch();
  }

  Future<void> uploadLicenseImage(
    Key entryKey, {
    required String imagePath,
  }) async {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.licenseImageUploadStatus = UploadImageRequestStatus.initial;
    _touch();

    final response = await _sharedRepo.uploadImage(
      image: File(imagePath),
      language: AppStrings.arabicLang,
      contentType: AppStrings.contentTypeMultiPartValue,
    );
    response.when(
      success: (result) {
        entry.licenseImageUrl = result.imageUrl;
        entry.licenseImageUploadStatus = UploadImageRequestStatus.success;
        safeEmit(state.copyWith(
          message: result.message,
          entries: [...state.entries],
        ));
      },
      failure: (error) {
        entry.licenseImageUploadStatus = UploadImageRequestStatus.failure;
        safeEmit(state.copyWith(
          message: error.errors.first,
          entries: [...state.entries],
        ));
      },
    );
  }

  void removeLicenseImage(Key entryKey) {
    final entry = state.entries.firstWhere((entry) => entry.key == entryKey);
    entry.licenseImageUrl = '';
    _touch();
  }

  void _touch() {
    safeEmit(state.copyWith(entries: [...state.entries]));
  }

  Future<void> submitLicenses() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = LicensesRequestBodyModel(
      licenses: state.entries.map((entry) => entry.toModel()).toList(),
    );

    final response = await _licensesRepo.submitLicenses(model);
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
