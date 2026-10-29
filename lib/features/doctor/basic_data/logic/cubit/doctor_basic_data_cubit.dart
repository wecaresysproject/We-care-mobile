import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/basic_data/data/models/doctor_basic_data_request_body_model.dart';
import 'package:we_care/features/doctor/basic_data/data/repos/doctor_basic_data_repo.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'doctor_basic_data_state.dart';

/// Static list — no backend endpoint exists yet for academic degrees.
/// Replace with a real lookup once one is defined.
const List<String> kAcademicDegreeOptions = [
  'بكالوريوس',
  'ماجستير',
  'دكتوراه',
  'زمالة',
  'استشاري',
];

/// Static list for now — the doctor-specialties-style endpoint isn't a
/// reliable fit for job grade, so this uses local data until a dedicated
/// endpoint is defined.
const List<String> kJobGradeOptions = [
  'طبيب امتياز',
  'طبيب مقيم',
  'أخصائي',
  'استشاري',
  'أستاذ مساعد',
  'أستاذ',
];

class DoctorBasicDataCubit extends Cubit<DoctorBasicDataState>
    with SafeEmitMixin<DoctorBasicDataState> {
  DoctorBasicDataCubit(this._sharedRepo, this._basicDataRepo)
      : super(DoctorBasicDataState.initial()) {
    for (final controller in [
      firstNameController,
      fatherNameController,
      familyNameController,
      professionalMobileController,
      contactMobileController,
      nationalIdController,
      shortBioController,
    ]) {
      controller.addListener(_updateHasChanges);
    }
  }

  final AppSharedRepo _sharedRepo;
  final DoctorBasicDataRepo _basicDataRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  final firstNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final familyNameController = TextEditingController();
  final professionalMobileController = TextEditingController();
  final contactMobileController = TextEditingController();
  final nationalIdController = TextEditingController();
  final shortBioController = TextEditingController();

  /// Loads the dropdown options and the doctor's saved basic data together.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await Future.wait([emitCountriesData(), _loadSavedBasicData()]);
  }

  Future<void> _loadSavedBasicData() async {
    final response = await _basicDataRepo.getBasicData();
    await response.when(
      success: (model) async {
        if (model == null) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        firstNameController.text = model.firstName;
        fatherNameController.text = model.fatherName;
        familyNameController.text = model.familyName;
        professionalMobileController.text = model.professionalMobileNumber;
        contactMobileController.text = model.contactMobileNumber;
        nationalIdController.text = model.nationalIdOrPassportNumber;
        shortBioController.text = model.shortBio;

        String? orNull(String value) => value.isEmpty ? null : value;
        safeEmit(state.copyWith(
          profileImageUrl: orNull(model.personalPhotoUrl),
          selectedJobGrade: orNull(model.jobGrade),
          selectedAcademicDegree: orNull(model.academicDegree),
          selectedGender: orNull(model.gender),
          birthDate: orNull(model.birthDate),
          selectedCountry: orNull(model.country),
          selectedGovernorate: orNull(model.governorate),
          selectedCity: orNull(model.city),
          professionalMobileCountryCode:
              orNull(model.professionalMobileCountryCode),
          contactMobileCountryCode: orNull(model.contactMobileCountryCode),
          nationalIdImageUrl: orNull(model.nationalIdOrPassportPhotoUrl),
          selectedLanguages: List<String>.from(model.spokenLanguages),
        ));

        // The cities list depends on the country, so load it for the saved
        // country before showing the form.
        await emitCitiesData();

        _changesTracker.setBaseline(_comparableJson());
        safeEmit(state.copyWith(
          loadStatus: RequestStatus.success,
          isEditMode: true,
          hasChanges: false,
        ));
      },
      failure: (error) async => safeEmit(state.copyWith(
        loadStatus: RequestStatus.failure,
        message: error.errors.first,
      )),
    );
  }

  DoctorBasicDataRequestBodyModel _buildRequestBody() =>
      DoctorBasicDataRequestBodyModel(
        personalPhotoUrl: state.profileImageUrl ?? '',
        firstName: firstNameController.text.trim(),
        fatherName: fatherNameController.text.trim(),
        familyName: familyNameController.text.trim(),
        jobGrade: state.selectedJobGrade ?? '',
        academicDegree: state.selectedAcademicDegree ?? '',
        gender: state.selectedGender ?? '',
        birthDate: state.birthDate ?? '',
        country: state.selectedCountry ?? '',
        governorate: state.selectedGovernorate ?? '',
        city: state.selectedCity ?? '',
        professionalMobileCountryCode: state.professionalMobileCountryCode,
        professionalMobileNumber: professionalMobileController.text.trim(),
        contactMobileCountryCode: state.contactMobileCountryCode,
        contactMobileNumber: contactMobileController.text.trim(),
        nationalIdOrPassportNumber: nationalIdController.text.trim(),
        nationalIdOrPassportPhotoUrl: state.nationalIdImageUrl ?? '',
        spokenLanguages: state.selectedLanguages,
        shortBio: shortBioController.text.trim(),
      );

  /// The request JSON used to detect changes. Languages are sorted so that
  /// removing a language and adding it back counts as unchanged.
  Map<String, dynamic> _comparableJson() {
    final json = _buildRequestBody().toJson();
    json['spokenLanguages'] = [...state.selectedLanguages]..sort();
    return json;
  }

  void _updateHasChanges() {
    final hasChanges = _changesTracker.hasChanges(_comparableJson());
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

  Future<void> emitCitiesData() async {
    if (state.selectedCountry == null) return;
    final response = await _sharedRepo.getCitiesBasedOnCountryName(
      language: AppStrings.arabicLang,
      countryName: state.selectedCountry!,
      userType: UserTypes.doctor.name.firstLetterToUpperCase,
    );
    response.when(
      success: (cities) => safeEmit(state.copyWith(citiesNames: cities)),
      failure: (error) => safeEmit(state.copyWith(message: error.errors.first)),
    );
  }

  void updateJobGrade(String? val) {
    safeEmit(state.copyWith(selectedJobGrade: val));
    _updateHasChanges();
  }

  void updateAcademicDegree(String? val) {
    safeEmit(state.copyWith(selectedAcademicDegree: val));
    _updateHasChanges();
  }

  void updateGender(String? val) {
    safeEmit(state.copyWith(selectedGender: val));
    _updateHasChanges();
  }

  void updateBirthDate(String? val) {
    safeEmit(state.copyWith(birthDate: val));
    _updateHasChanges();
  }

  void updateCountry(String? val) {
    safeEmit(state.copyWith(selectedCountry: val, selectedCity: null));
    _updateHasChanges();
  }

  void updateGovernorate(String? val) {
    safeEmit(state.copyWith(selectedGovernorate: val));
    _updateHasChanges();
  }

  void updateCity(String? val) {
    safeEmit(state.copyWith(selectedCity: val));
    _updateHasChanges();
  }

  void updateProfessionalMobileCountryCode(String code) {
    safeEmit(state.copyWith(professionalMobileCountryCode: code));
    _updateHasChanges();
  }

  void updateContactMobileCountryCode(String code) {
    safeEmit(state.copyWith(contactMobileCountryCode: code));
    _updateHasChanges();
  }

  void toggleSpokenLanguage(String language) {
    final current = List<String>.from(state.selectedLanguages);
    if (current.contains(language)) {
      current.remove(language);
    } else {
      current.add(language);
    }
    safeEmit(state.copyWith(selectedLanguages: current));
    _updateHasChanges();
  }

  void removeSpokenLanguage(String language) {
    final current = List<String>.from(state.selectedLanguages)
      ..remove(language);
    safeEmit(state.copyWith(selectedLanguages: current));
    _updateHasChanges();
  }

  Future<void> uploadProfileImage({required String imagePath}) async {
    safeEmit(
      state.copyWith(
          profileImageUploadStatus: UploadImageRequestStatus.initial),
    );
    final response = await _sharedRepo.uploadImage(
      image: File(imagePath),
      language: AppStrings.arabicLang,
      contentType: AppStrings.contentTypeMultiPartValue,
    );
    response.when(
      success: (result) => safeEmit(
        state.copyWith(
          message: result.message,
          profileImageUrl: result.imageUrl,
          profileImageUploadStatus: UploadImageRequestStatus.success,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          message: error.errors.first,
          profileImageUploadStatus: UploadImageRequestStatus.failure,
        ),
      ),
    );
    _updateHasChanges();
  }

  void removeProfileImage() {
    safeEmit(state.copyWith(profileImageUrl: ''));
    _updateHasChanges();
  }

  Future<void> uploadNationalIdImage({required String imagePath}) async {
    safeEmit(
      state.copyWith(
        nationalIdImageUploadStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _sharedRepo.uploadImage(
      image: File(imagePath),
      language: AppStrings.arabicLang,
      contentType: AppStrings.contentTypeMultiPartValue,
    );
    response.when(
      success: (result) => safeEmit(
        state.copyWith(
          message: result.message,
          nationalIdImageUrl: result.imageUrl,
          nationalIdImageUploadStatus: UploadImageRequestStatus.success,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          message: error.errors.first,
          nationalIdImageUploadStatus: UploadImageRequestStatus.failure,
        ),
      ),
    );
    _updateHasChanges();
  }

  void removeNationalIdImage() {
    safeEmit(state.copyWith(nationalIdImageUrl: ''));
    _updateHasChanges();
  }

  Future<void> submitBasicData() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody();

    final response = await _basicDataRepo.submitBasicData(model);
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
    firstNameController.dispose();
    fatherNameController.dispose();
    familyNameController.dispose();
    professionalMobileController.dispose();
    contactMobileController.dispose();
    nationalIdController.dispose();
    shortBioController.dispose();
    return super.close();
  }
}
