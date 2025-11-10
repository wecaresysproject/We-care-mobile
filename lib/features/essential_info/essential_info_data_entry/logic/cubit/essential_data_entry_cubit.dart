// essential_data_entry_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
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
      TextEditingController(); //                   'الحى /العزبة /الشياخة'

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

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
    'A',
    'B',
    'AB',
    'O',
  ];

  Future<void> postUserBasicData(S localization) async {
    emit(state.copyWith(submissionStatus: RequestStatus.loading));

    try {
      final model = UserEssentialInfoRequestBodyModel(
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
        areaOrDistrict: userAddress.text.trim().isNotEmpty
            ? userAddress.text.trim()
            : localization.no_data_entered,
        bloodType: state.selectedBloodType ?? localization.no_data_entered,
        insuranceDetails: InsuranceDetails(
          insuranceStatus: state.hasMedicalInsurance ?? false,
          insuranceCompany:
              state.insuranceCompany ?? localization.no_data_entered,
          insuranceCoverageExpiryDate:
              state.insuranceEndDate ?? localization.no_data_entered,
          insuranceCardPhotoUrl:
              state.insuranceCardImagePath ?? localization.no_data_entered,
          additionalInsuranceTerms:
              additionalInsuranceConditionsController.text.trim().isNotEmpty
                  ? additionalInsuranceConditionsController.text.trim()
                  : localization.no_data_entered,
        ),
        disabilityLevel: state.disabilityLevel ?? localization.no_data_entered,
        disabilityType: (disabilityTypeDetailsController.text.trim().isNotEmpty
            ? disabilityTypeDetailsController.text.trim()
            : localization.no_data_entered),
        socialStatus: state.socialStatus,
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
  void updateHasMedicalInsurance(bool? val) {
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

  // Validation (simple: require name, birth date, national id, mobile)
  void validateRequiredFields() {
    final bool isValid = fullNameController.text.trim().isNotEmpty;

    emit(state.copyWith(isFormValidated: isValid));
  }

  // Called by UI when fields change (you can call selectively too)
  void onAnyFieldChanged() {
    validateRequiredFields();
  }

  // Dummy submit (simulate network) — will set loading -> success (or failure)
  // Future<void> submitEssentialData() async {
  //   // Before submit validate one more time
  //   validateRequiredFields();
  //   if (!state.isFormValidated) {
  //     emit(state.copyWith(
  //         submissionStatus: RequestStatus.failure,
  //         message: 'برجاء إكمال الحقول المطلوبة'));
  //     return;
  //   }

  //   emit(state.copyWith(submissionStatus: RequestStatus.loading));

  //   try {
  //     // simulate network delay
  //     await Future.delayed(const Duration(seconds: 1, milliseconds: 200));

  //     // assemble payload (for debugging / future integration)
  //     final payload = {
  //       'fullName': fullNameController.text.trim(),
  //       'birthDate': state.birthDate,
  //       'gender': state.selectedGender,
  //       'nationalId': nationalIdController.text.trim(),
  //       'nationality': state.selectedNationality,
  //       'maritalStatus': state.selectedMaritalStatus,
  //       'email': emailController.text.trim(),
  //       'hasInsurance': state.hasMedicalInsurance,
  //       'hasDisability': state.hasDisability,
  //       'disabilityType': state.selectedDisabilityType,
  //       'disabilityDetails': disabilityTypeDetailsController.text.trim(),
  //     };

  //     // For now: print payload and emit success
  //     // ignore: avoid_print
  //     print('EssentialData payload: $payload');

  //     emit(state.copyWith(
  //       submissionStatus: RequestStatus.success,
  //       message: 'تم حفظ البيانات بنجاح',
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       submissionStatus: RequestStatus.failure,
  //       message: e.toString(),
  //     ));
  //   } finally {
  //     // reset loading after short delay so UI can show status
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     emit(state.copyWith(submissionStatus: RequestStatus.success));
  //   }
  // }

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
