// essential_data_entry_cubit.dart
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/essential_info/data/models/get_user_essential_info_response_model.dart';
import 'package:we_care/features/essential_info/data/models/user_essential_info_request_body_model.dart';
import 'package:we_care/features/essential_info/data/repos/essential_info_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'essential_data_entry_state.dart';

class EssentialDataEntryCubit extends Cubit<EssentialDataEntryState> {
  final AppSharedRepo _sharedRepo;
  final EssentialInfoDataEntryRepo essentialInfoDataEntryRepo;

  EssentialDataEntryCubit(
    this._sharedRepo,
    this.essentialInfoDataEntryRepo,
  ) : super(EssentialDataEntryState.initial());

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

  final TextEditingController familyDoctorNameController =
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
    'A',
    'B',
    'O',
    'AB',
  ];

  Future<void> submitEditsOnUserEssentialInfo(S localization) async {
    emit(state.copyWith(submissionStatus: RequestStatus.loading));

    try {
      final updatedModel = UserEssentialInfoRequestBodyModel(
        familyDoctorPhoneNumber: familyDoctorPhoneNumberController.text.trim(),
        fullName: fullNameController.text.trim(),
        dateOfBirth: state.birthDate!,
        nationalID: nationalIdController.text.trim(),
        email: emailController.text.trim(),
        personalPhotoUrl: state.userPersonalImage!,
        country: state.selectedNationality!,
        city: state.selectedCity!,
        areaOrDistrict: exactLocation.text.trim(), //!check it later
        bloodType: state.selectedBloodType!,
        insuranceDetails: InsuranceDetails(
          insuranceStatus: state.hasMedicalInsurance!,
          insuranceCompany: insuranceCompanyController.text,
          insuranceCoverageExpiryDate: state.insuranceEndDate!,
          insuranceCardPhotoUrl: state.insuranceCardPhotoUrl,
          additionalInsuranceTerms:
              additionalInsuranceConditionsController.text.trim(),
        ),
        disabilityLevel: state.disabilityLevel!,
        disabilityType: disabilityTypeDetailsController.text.trim(),
        socialStatus: state.socialStatus!,
        numberOfChildren: int.parse(numberOfChildrenController.text.isEmpty
            ? '0'
            : numberOfChildrenController.text),
        familyDoctorName: familyDoctorNameController.text.trim(),
        workHours: noOfWoringHours.text.trim(),
        emergencyContact1: mainEmergencyPhoneController.text.trim(),
        emergencyContact2: anotherEmergencyPhoneController.text.trim(),
      );

      final response = await essentialInfoDataEntryRepo.updateUserEssentialInfo(
        updatedModel,
        AppStrings.arabicLang,
      );

      response.when(
        success: (message) {
          emit(
            state.copyWith(
              message: message,
              submissionStatus: RequestStatus.success,
            ),
          );
        },
        failure: (error) {
          emit(
            state.copyWith(
              message: error.errors.first,
              submissionStatus: RequestStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          submissionStatus: RequestStatus.failure,
        ),
      );
    }
  }

  Future<void> loadUserPersonalDetailsDataForEditing(
      UserEssentialInfoData editingModel) async {
    emit(
      state.copyWith(
        birthDate: editingModel.dateOfBirth,
        selectedNationality: editingModel.country,
        selectedCity: editingModel.city,
        userPersonalImage: editingModel.personalPhotoUrl, //! check it later
        selectedBloodType: editingModel.bloodType,
        selectedDisabilityType: editingModel.disabilityType,
        disabilityLevel:
            editingModel.disabilityDetails, //!TODO: check this later
        socialStatus: editingModel.socialStatus,
        hasMedicalInsurance:
            true, //! TODO: check this later , need to change it
        insuranceEndDate: editingModel.insuranceCoverageExpiryDate ?? '',
        insuranceCardPhotoUrl: editingModel.insuranceCardPhotoUrl,
        isEditMode: true,
      ),
    );
    fullNameController.text = editingModel.fullName!;
    nationalIdController.text = editingModel.nationalID!;
    emailController.text = editingModel.email!;
    exactLocation.text = editingModel.areaOrDistrict!;
    userAddress.text =
        editingModel.areaOrDistrict!; //! الحي او الشياخة من العرض الاول

    insuranceCompanyController.text = editingModel.insuranceCompany ?? '';
    additionalInsuranceConditionsController.text =
        editingModel.additionalTerms ?? '';

    disabilityTypeDetailsController.text = "مش موجود في العرض";
    noOfWoringHours.text = editingModel.workHours!;

    familyDoctorNameController.text = editingModel.familyDoctorName!;
    familyDoctorPhoneNumberController.text =
        editingModel.familyDoctorPhoneNumber!;
    numberOfChildrenController.text = editingModel.numberOfChildren.toString();

    mainEmergencyPhoneController.text = editingModel.emergencyContact1!;
    anotherEmergencyPhoneController.text = editingModel.emergencyContact2!;
    validateRequiredFields();
    await initialRequests();
  }

  initialRequests() async {
    await emitCountriesData();
  }

  Future<void> uploadProfileImage({required String imagePath}) async {
    emit(
      state.copyWith(
        uploadImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _sharedRepo.uploadImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            userPersonalImage: response.imageUrl,
            uploadImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            uploadImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> uploadInsuranceCardImage({required String imagePath}) async {
    emit(
      state.copyWith(
        uploadImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _sharedRepo.uploadImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            insuranceCardPhotoUrl: response.imageUrl,
            uploadImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            uploadImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> postUserBasicData(S localization) async {
    emit(state.copyWith(submissionStatus: RequestStatus.loading));

    try {
      final model = UserEssentialInfoRequestBodyModel(
        familyDoctorPhoneNumber:
            familyDoctorPhoneNumberController.text.trim().isNotEmpty
                ? familyDoctorPhoneNumberController.text.trim()
                : localization.no_data_entered,
        fullName: fullNameController.text.trim().isNotEmpty
            ? fullNameController.text.trim()
            : localization.no_data_entered,
        dateOfBirth: state.birthDate ?? localization.no_data_entered,
        nationalID: nationalIdController.text.trim().isNotEmpty
            ? nationalIdController.text.trim()
            : localization.no_data_entered,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : localization.no_data_entered,
        personalPhotoUrl:
            state.userPersonalImage ?? localization.no_data_entered,
        country: state.selectedNationality ?? localization.no_data_entered,
        city: state.selectedCity ?? localization.no_data_entered,
        areaOrDistrict: exactLocation.text.trim().isNotEmpty
            ? exactLocation.text.trim()
            : localization.no_data_entered,
        bloodType: state.selectedBloodType ?? localization.no_data_entered,
        insuranceDetails: InsuranceDetails(
          insuranceStatus: state.hasMedicalInsurance ?? false,
          insuranceCompany:
              state.insuranceCompany ?? localization.no_data_entered,
          insuranceCoverageExpiryDate:
              state.insuranceEndDate ?? localization.no_data_entered,
          insuranceCardPhotoUrl:
              state.insuranceCardPhotoUrl ?? localization.no_data_entered,
          additionalInsuranceTerms:
              additionalInsuranceConditionsController.text.trim().isNotEmpty
                  ? additionalInsuranceConditionsController.text.trim()
                  : localization.no_data_entered,
        ),
        disabilityLevel: state.disabilityLevel ?? localization.no_data_entered,
        disabilityType: (disabilityTypeDetailsController.text.trim().isNotEmpty
            ? disabilityTypeDetailsController.text.trim()
            : localization.no_data_entered),
        socialStatus: state.socialStatus ?? localization.no_data_entered,
        numberOfChildren: int.tryParse(numberOfChildrenController.text) ?? 0,
        familyDoctorName: familyDoctorNameController.text.trim().isNotEmpty
            ? familyDoctorNameController.text.trim()
            : localization.no_data_entered,
        workHours: noOfWoringHours.text.trim().isNotEmpty
            ? noOfWoringHours.text.trim()
            : localization.no_data_entered,
        emergencyContact1: mainEmergencyPhoneController.text.trim().isNotEmpty
            ? mainEmergencyPhoneController.text.trim()
            : localization.no_data_entered,
        emergencyContact2:
            anotherEmergencyPhoneController.text.trim().isNotEmpty
                ? anotherEmergencyPhoneController.text.trim()
                : localization.no_data_entered,
      );

      final response = await essentialInfoDataEntryRepo.postUserEssentialInfo(
        model,
        AppStrings.arabicLang,
      );

      response.when(
        success: (message) {
          emit(
            state.copyWith(
              message: message,
              submissionStatus: RequestStatus.success,
            ),
          );
        },
        failure: (error) {
          emit(
            state.copyWith(
              message: error.errors.first,
              submissionStatus: RequestStatus.failure,
            ),
          );
        },
      );
    } catch (e) {
      emit(
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
        emit(
          state.copyWith(
            countriesNames: response,
          ),
        );
      },
      failure: (error) {
        emit(
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
        emit(
          state.copyWith(
            citiesNames: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  // Update functions
  void updateIsMarriedOrNot(String? val) =>
      emit(state.copyWith(socialStatus: val));
  void updateDisabilityLevel(String? val) =>
      emit(state.copyWith(disabilityLevel: val));

  void updateNationality(String? val) =>
      emit(state.copyWith(selectedNationality: val));
  void updateCity(String? val) => emit(state.copyWith(selectedCity: val));

  void updateMaritalStatus(String? val) =>
      emit(state.copyWith(selectedMaritalStatus: val));

  void updateInsuranceEndDate(String? val) =>
      emit(state.copyWith(insuranceEndDate: val));

  void updateBloodType(String? val) =>
      emit(state.copyWith(selectedBloodType: val));

  void updateWeeklyWorkingHours(String? val) =>
      emit(state.copyWith(weeklyWorkingHours: val));

  void updateBirthDate(String? val) => emit(state.copyWith(birthDate: val));
  void updateInsuranceCompanyName(String? val) =>
      emit(state.copyWith(insuranceCompany: val));

  // Yes/No updates
  void updateHasMedicalInsurance(bool? val, S locale) {
    {
      emit(state.copyWith(hasMedicalInsurance: val));
      if (val == false) {
        // Clear insurance-specific fields
        emit(
          state.copyWith(
            insuranceCompany: null,
            insuranceEndDate: null,
            insuranceAdditionalConditions: null,
            insuranceCardImagePath: null,
          ),
        );
      }
    }
  }

  // Validation (simple: require name, birth date, national id, mobile)
  void validateRequiredFields() {
    final bool isValid = fullNameController.text.trim().isNotEmpty;

    emit(state.copyWith(isFormValidated: isValid));
  }

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
    familyDoctorNameController.dispose();
    numberOfChildrenController.dispose();
    mainEmergencyPhoneController.dispose();
    anotherEmergencyPhoneController.dispose();

    return super.close();
  }
}
