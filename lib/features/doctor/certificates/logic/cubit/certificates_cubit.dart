import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificate_section_type.dart';
import 'package:we_care/features/doctor/certificates/data/models/certificates_request_body_model.dart';
import 'package:we_care/features/doctor/certificates/data/repos/certificates_repo.dart';
import 'package:we_care/features/doctor/certificates/logic/cubit/certificate_form_entry.dart';

part 'certificates_state.dart';

class CertificatesCubit extends Cubit<CertificatesState>
    with SafeEmitMixin<CertificatesState> {
  CertificatesCubit(this._sharedRepo, this._certificatesRepo)
      : super(CertificatesState.initial());

  final AppSharedRepo _sharedRepo;
  final CertificatesRepo _certificatesRepo;

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

  void addCertificate(CertificateSectionType section) {
    final sections =
        Map<CertificateSectionType, List<CertificateFormEntry>>.from(
            state.sections);
    sections[section] = [...sections[section]!, CertificateFormEntry()];
    safeEmit(state.copyWith(sections: sections));
  }

  void removeCertificate(CertificateSectionType section, Key entryKey) {
    final entries = state.sections[section]!;
    if (entries.length <= 1) return;

    final removed = entries.firstWhere((entry) => entry.key == entryKey);
    removed.dispose();

    final sections =
        Map<CertificateSectionType, List<CertificateFormEntry>>.from(
            state.sections);
    sections[section] =
        entries.where((entry) => entry.key != entryKey).toList();
    safeEmit(state.copyWith(sections: sections));
  }

  void updateCertificateCountry(
    CertificateSectionType section,
    Key entryKey,
    String? country,
  ) {
    final entry =
        state.sections[section]!.firstWhere((entry) => entry.key == entryKey);
    entry.selectedCountry = country;
    _touchSection(section);
  }

  void updateCertificateDate(
    CertificateSectionType section,
    Key entryKey,
    String date,
  ) {
    final entry =
        state.sections[section]!.firstWhere((entry) => entry.key == entryKey);
    entry.obtainedDate = date;
    _touchSection(section);
  }

  void _touchSection(CertificateSectionType section) {
    final sections =
        Map<CertificateSectionType, List<CertificateFormEntry>>.from(
            state.sections);
    sections[section] = [...sections[section]!];
    safeEmit(state.copyWith(sections: sections));
  }

  Future<void> submitCertificates() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = CertificatesRequestBodyModel(
      sections: state.sections.map(
        (section, entries) => MapEntry(
          section,
          entries.map((entry) => entry.toModel()).toList(),
        ),
      ),
    );

    final response = await _certificatesRepo.submitCertificates(model);
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
    for (final entries in state.sections.values) {
      for (final entry in entries) {
        entry.dispose();
      }
    }
    return super.close();
  }
}
