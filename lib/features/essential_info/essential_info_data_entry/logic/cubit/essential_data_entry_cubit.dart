// essential_data_entry_cubit.dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/essential_info/data/models/get_user_essential_info_response_model.dart';
import 'package:we_care/features/essential_info/data/models/user_essential_info_request_body_model.dart';
import 'package:we_care/features/essential_info/data/repos/essential_info_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'essential_data_entry_state.dart';

class EssentialDataEntryCubit extends Cubit<EssentialDataEntryState>
    with SafeEmitMixin<EssentialDataEntryState> {
  final AppSharedRepo _sharedRepo;
  final EssentialInfoDataEntryRepo essentialInfoDataEntryRepo;

  EssentialDataEntryCubit(
    this._sharedRepo,
    this.essentialInfoDataEntryRepo,
  ) : super(EssentialDataEntryState.initial());

  final formKey = GlobalKey<FormState>();

  // Controllers (managed by Cubit)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController exactLocation = TextEditingController(); // منطقت
  final TextEditingController userAddress =
      TextEditingController(); // الحي او الشياخة

  final TextEditingController disabilityTypeDetailsController =
      TextEditingController();

  final TextEditingController noOfWoringHours = TextEditingController();

  final TextEditingController additionalInsuranceConditionsController =
      TextEditingController();

  final TextEditingController familyDoctorPhoneNumberController =
      TextEditingController();
  final TextEditingController numberOfChildrenController =
      TextEditingController();

  final TextEditingController mainEmergencyPhoneController =
      TextEditingController();

  final TextEditingController anotherEmergencyPhoneController =
      TextEditingController();

  final TextEditingController insuranceCompanyController =
      TextEditingController();

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'A (غير معروف +/–)',
    'B+',
    'B-',
    'B (غير معروف +/–)',
    'AB+',
    'AB-',
    'AB (غير معروف +/–)',
    'O+',
    'O-',
    'O (غير معروف +/–)',
  ];

  /// نص الـ controller بعد التنظيف، أو placeholder لو فاضى.
  String _textOrPlaceholder(TextEditingController controller, S localization) {
    final text = controller.text.trim();
    return text.isNotEmpty ? text : localization.no_data_entered;
  }

  /// تفاصيل التأمين — مصدر واحد للإضافة والتعديل عشان الاتنين يبعتوا نفس الحقول.
  /// بنقرا من الـ controllers مباشرة لأنها هى اللى المستخدم بيكتب فيها فعلياً.
  InsuranceDetails _buildInsuranceDetails(S localization) {
    final hasInsurance = state.hasMedicalInsurance ?? false;

    if (!hasInsurance) {
      return InsuranceDetails(
        insuranceStatus: false,
        insuranceCompany: localization.no_data_entered,
        insuranceCoverageExpiryDate: localization.no_data_entered,
        insuranceCardPhotoUrl: localization.no_data_entered,
        additionalInsuranceTerms: localization.no_data_entered,
      );
    }

    return InsuranceDetails(
      insuranceStatus: true,
      insuranceCompany:
          _textOrPlaceholder(insuranceCompanyController, localization),
      insuranceCoverageExpiryDate:
          state.insuranceEndDate ?? localization.no_data_entered,
      insuranceCardPhotoUrl:
          state.insuranceCardPhotoUrl ?? localization.no_data_entered,
      additionalInsuranceTerms: _textOrPlaceholder(
        additionalInsuranceConditionsController,
        localization,
      ),
    );
  }

  Future<void> emitDoctorNames() async {
    final response = await _sharedRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            doctors: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> submitEditsOnUserEssentialInfo(S localization) async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    try {
      final updatedModel = UserEssentialInfoRequestBodyModel(
        gender: state.selectedGender,
        familyDoctorPhoneNumber: _textOrPlaceholder(
          familyDoctorPhoneNumberController,
          localization,
        ),
        fullName: _textOrPlaceholder(fullNameController, localization),
        dateOfBirth: state.birthDate ?? localization.no_data_entered,
        nationalID: _textOrPlaceholder(nationalIdController, localization),
        email: _textOrPlaceholder(emailController, localization),
        personalPhotoUrl:
            state.userPersonalImage ?? localization.no_data_entered,
        country: state.selectedNationality ?? localization.no_data_entered,
        city: state.selectedCity ?? localization.no_data_entered,
        areaOrDistrict:
            _textOrPlaceholder(exactLocation, localization), //!check it later
        bloodType: state.selectedBloodType ?? localization.no_data_entered,
        insuranceDetails: _buildInsuranceDetails(localization),
        disabilityLevel: state.disabilityLevel ?? localization.no_data_entered,
        disabilityType: _textOrPlaceholder(
          disabilityTypeDetailsController,
          localization,
        ),
        socialStatus: state.socialStatus ?? localization.no_data_entered,
        numberOfChildren:
            int.tryParse(numberOfChildrenController.text.trim()) ?? 0,
        familyDoctorName:
            state.selectedFamilyDoctorName ?? localization.no_data_entered,
        workHours: _textOrPlaceholder(noOfWoringHours, localization),
        emergencyContact1:
            _textOrPlaceholder(mainEmergencyPhoneController, localization),
        emergencyContact2:
            _textOrPlaceholder(anotherEmergencyPhoneController, localization),
      );

      final response = await essentialInfoDataEntryRepo.updateUserEssentialInfo(
        updatedModel,
        AppStrings.arabicLang,
      );

      response.when(
        success: (message) {
          safeEmit(
            state.copyWith(
              message: message,
              submissionStatus: RequestStatus.success,
            ),
          );
        },
        failure: (error) {
          safeEmit(
            state.copyWith(
              message: error.errors.first,
              submissionStatus: RequestStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          message: e.toString(),
          submissionStatus: RequestStatus.failure,
        ),
      );
    }
  }

  Future<void> loadUserPersonalDetailsDataForEditing(
      UserEssentialInfoData editingModel) async {
    safeEmit(
      state.copyWith(
        birthDate: editingModel.dateOfBirth,
        selectedGender: editingModel.gender,
        selectedNationality: editingModel.country,
        selectedCity: editingModel.city,
        userPersonalImage: editingModel.personalPhotoUrl, //! check it later
        selectedBloodType: editingModel.bloodType,
        selectedDisabilityType: editingModel.disabilityType,
        disabilityLevel:
            editingModel.disabilityDetails, //!TODO: check this later
        socialStatus: editingModel.socialStatus,
        hasMedicalInsurance: editingModel.insuranceStatus ??
            false, //! TODO: check this later , need to change it
        insuranceEndDate: editingModel.insuranceCoverageExpiryDate ?? '',
        insuranceCardPhotoUrl: editingModel.insuranceCardPhotoUrl,
        isEditMode: true,
        selectedFamilyDoctorName: editingModel.familyDoctorName,
      ),
    );
    fullNameController.text = editingModel.fullName ?? '';
    nationalIdController.text = editingModel.nationalID ?? '';
    emailController.text = editingModel.email ?? '';
    exactLocation.text = editingModel.areaOrDistrict ?? '';
    userAddress.text =
        editingModel.areaOrDistrict ?? ''; //! الحي او الشياخة من العرض الاول

    insuranceCompanyController.text = editingModel.insuranceCompany ?? '';
    additionalInsuranceConditionsController.text =
        editingModel.additionalTerms ?? '';

    disabilityTypeDetailsController.text = editingModel.disabilityType ?? '';
    noOfWoringHours.text = editingModel.workHours ?? '';

    familyDoctorPhoneNumberController.text =
        editingModel.familyDoctorPhoneNumber ?? '';
    numberOfChildrenController.text =
        (editingModel.numberOfChildren ?? 0).toString();

    mainEmergencyPhoneController.text = editingModel.emergencyContact1 ?? '';
    anotherEmergencyPhoneController.text = editingModel.emergencyContact2 ?? '';
    validateRequiredFields();
    await initialRequests();
  }

  Future<void> initialRequests() async {
    await Future.wait(
      [
        emitCountriesData(),
        //! لازم تتنادى هنا كمان عشان في حالة التعديل تكون قائمة المدن متحمّلة
        //! على حسب دولة المستخدم المحفوظة، مش فاضية لحد ما يغيّر الدولة
        emitCitiesData(),
        emitDoctorNames(),
        emitModuleGuidanceData(),
      ],
    );
  }

  Future<void> emitModuleGuidanceData() async {
    final response = await _sharedRepo.getModuleGuidance(
      WeCareMedicalModules.profileDataEntry.name,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            moduleGuidanceData: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  Future<void> uploadProfileImage({required String imagePath}) async {
    safeEmit(
      state.copyWith(
        profileImageUploadStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _sharedRepo.uploadImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            message: response.message,
            userPersonalImage: response.imageUrl,
            profileImageUploadStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            profileImageUploadStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> uploadInsuranceCardImage({required String imagePath}) async {
    safeEmit(
      state.copyWith(
        insuranceImageUploadStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _sharedRepo.uploadImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            message: response.message,
            insuranceCardPhotoUrl: response.imageUrl,
            insuranceImageUploadStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            insuranceImageUploadStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> postUserBasicData(S localization) async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    try {
      final model = UserEssentialInfoRequestBodyModel(
        gender: state.selectedGender ?? localization.no_data_entered,
        familyDoctorPhoneNumber: _textOrPlaceholder(
          familyDoctorPhoneNumberController,
          localization,
        ),
        fullName: _textOrPlaceholder(fullNameController, localization),
        dateOfBirth: state.birthDate ?? localization.no_data_entered,
        nationalID: _textOrPlaceholder(nationalIdController, localization),
        email: _textOrPlaceholder(emailController, localization),
        personalPhotoUrl:
            state.userPersonalImage ?? localization.no_data_entered,
        country: state.selectedNationality ?? localization.no_data_entered,
        city: state.selectedCity ?? localization.no_data_entered,
        areaOrDistrict: _textOrPlaceholder(exactLocation, localization),
        bloodType: state.selectedBloodType ?? localization.no_data_entered,
        insuranceDetails: _buildInsuranceDetails(localization),
        disabilityLevel: state.disabilityLevel ?? localization.no_data_entered,
        disabilityType: _textOrPlaceholder(
          disabilityTypeDetailsController,
          localization,
        ),
        socialStatus: state.socialStatus ?? localization.no_data_entered,
        numberOfChildren:
            int.tryParse(numberOfChildrenController.text.trim()) ?? 0,
        familyDoctorName:
            state.selectedFamilyDoctorName ?? localization.no_data_entered,
        workHours: _textOrPlaceholder(noOfWoringHours, localization),
        emergencyContact1:
            _textOrPlaceholder(mainEmergencyPhoneController, localization),
        emergencyContact2:
            _textOrPlaceholder(anotherEmergencyPhoneController, localization),
      );

      final response = await essentialInfoDataEntryRepo.postUserEssentialInfo(
        model,
        AppStrings.arabicLang,
      );

      response.when(
        success: (message) {
          safeEmit(
            state.copyWith(
              message: message,
              submissionStatus: RequestStatus.success,
            ),
          );
        },
        failure: (error) {
          safeEmit(
            state.copyWith(
              message: error.errors.first,
              submissionStatus: RequestStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          message: e.toString(),
          submissionStatus: RequestStatus.failure,
        ),
      );
    }
  }

  Future<void> emitCountriesData() async {
    final response = await _sharedRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            countriesNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  //emit cities data
  Future<void> emitCitiesData() async {
    final response = await _sharedRepo.getCitiesBasedOnCountryName(
      language: AppStrings.arabicLang,
      countryName: state.selectedNationality ?? "Egypt",
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            citiesNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  // Update functions
  void updateIsMarriedOrNot(String? val) =>
      safeEmit(state.copyWith(socialStatus: val));

  void updateGender(String? val) {
    log("gender : $val");
    safeEmit(
      state.copyWith(
        selectedGender: val,
      ),
    );
  }

  void updateFamilyDoctorName(String? val) =>
      safeEmit(state.copyWith(selectedFamilyDoctorName: val));

  void updateDisabilityLevel(String? val) =>
      safeEmit(state.copyWith(disabilityLevel: val));

  void updateNationality(String? val) =>
      safeEmit(state.copyWith(selectedNationality: val));

  void updateCity(String? val) => safeEmit(state.copyWith(selectedCity: val));

  void updateMaritalStatus(String? val) =>
      safeEmit(state.copyWith(selectedMaritalStatus: val));

  void updateInsuranceEndDate(String? val) =>
      safeEmit(state.copyWith(insuranceEndDate: val));

  void updateBloodType(String? val) =>
      safeEmit(state.copyWith(selectedBloodType: val));

  void updateWeeklyWorkingHours(String? val) =>
      safeEmit(state.copyWith(weeklyWorkingHours: val));

  void updateBirthDate(String? val) => safeEmit(state.copyWith(birthDate: val));

  void updateInsuranceCompanyName(String? val) =>
      safeEmit(state.copyWith(insuranceCompany: val));

  // Yes/No updates
  void updateHasMedicalInsurance(bool? val, S locale) {
    if (val == false) {
      // مسح بيانات التأمين من الـ state ومن الـ controllers مع بعض،
      // لأن الـ submit بيقرا من الـ controllers فلو سيبناها هتتبعت تانى.
      insuranceCompanyController.clear();
      additionalInsuranceConditionsController.clear();

      safeEmit(
        state.copyWith(
          hasMedicalInsurance: val,
          insuranceCompany: null,
          insuranceEndDate: null,
          insuranceAdditionalConditions: null,
          insuranceCardImagePath: null,
          insuranceCardPhotoUrl: null,
        ),
      );
      return;
    }

    safeEmit(state.copyWith(hasMedicalInsurance: val));
  }

  // Validation (simple: require name, birth date, national id, mobile)
  void validateRequiredFields() {
    final bool isValid = fullNameController.text.trim().isNotEmpty;

    safeEmit(state.copyWith(isFormValidated: isValid));
  }

  void onRemoveProfileImage() => safeEmit(
        state.copyWith(
          userPersonalImage: "",
        ),
      );
  void onRemoveInsuranceCardImage() => safeEmit(
        state.copyWith(
          insuranceCardPhotoUrl: "",
        ),
      );

  @override
  Future<void> close() async {
    // dispose controllers
    fullNameController.dispose();
    nationalIdController.dispose();
    emailController.dispose();
    exactLocation.dispose();
    userAddress.dispose();
    noOfWoringHours.dispose();
    familyDoctorPhoneNumberController.dispose();

    disabilityTypeDetailsController.dispose();
    additionalInsuranceConditionsController.dispose();
    numberOfChildrenController.dispose();
    mainEmergencyPhoneController.dispose();
    anotherEmergencyPhoneController.dispose();
    return super.close();
  }
}
