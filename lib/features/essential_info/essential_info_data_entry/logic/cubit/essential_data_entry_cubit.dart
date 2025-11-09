// essential_data_entry_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

part 'essential_data_entry_state.dart';

class EssentialDataEntryCubit extends Cubit<EssentialDataEntryState> {
  EssentialDataEntryCubit() : super(EssentialDataEntryState.initial());

  // Controllers (managed by Cubit)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController disabilityTypeDetailsController =
      TextEditingController();

  final TextEditingController additionalInsuranceConditionsController =
      TextEditingController();

  final TextEditingController familyDoctorNameController =
      TextEditingController();
  final TextEditingController numberOfChildrenController =
      TextEditingController();

  final TextEditingController mainEmergencyPhoneController =
      TextEditingController();

  final TextEditingController anotherEmergencyPhoneController =
      TextEditingController();

  // Option lists (logical options)
  final List<String> genders = ['ذكر', 'أنثى', 'غير ثنائي'];
  final List<String> religions = ['مسلم', 'مسيحي', 'يهودي', 'أخرى'];
  final List<String> nationalities = ['مصري', 'سعودي', 'أمريكي', 'أخرى'];
  final List<String> maritalStatus = [
    'أعزب/غير متزوج',
    'متزوج',
    'مطلق',
    'أرمل'
  ];
  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  final List<String> employmentStatus = [
    'طالب',
    'موظف',
    'عامل حر',
    'متقاعد',
    'لا يعمل'
  ];
  final List<String> insuranceTypes = [
    'تأمين حكومي',
    'تأمين خاص',
    'تأمين شركات',
    'لا يوجد'
  ];
  final List<String> disabilityTypes = [
    'إعاقة حركية',
    'إعاقة سمعية',
    'إعاقة بصرية',
    'إعاقة ذهنية',
    'غير ذلك'
  ];

  // Update functions
  void updateGender(String? val) => emit(state.copyWith(selectedGender: val));
  void updateIsMarriedOrNot(bool? val) => emit(state.copyWith(isMarried: val));

  void updateReligion(String? val) =>
      emit(state.copyWith(selectedReligion: val));

  void updateNationality(String? val) =>
      emit(state.copyWith(selectedNationality: val));
  void updateCity(String? val) => emit(state.copyWith(selectedCity: val));

  void updateArea(String? val) => emit(state.copyWith(selectedArea: val));

  void updateNeighborhood(String? val) =>
      emit(state.copyWith(selectedNeighborhood: val));

  void updateMaritalStatus(String? val) =>
      emit(state.copyWith(selectedMaritalStatus: val));

  void updateInsuranceEndDate(String? val) =>
      emit(state.copyWith(insuranceEndDate: val));

  void updateBloodType(String? val) =>
      emit(state.copyWith(selectedBloodType: val));

  void updateWeeklyWorkingHours(String? val) =>
      emit(state.copyWith(weeklyWorkingHours: val));

  void updateEmploymentStatus(String? val) =>
      emit(state.copyWith(selectedEmploymentStatus: val));

  void updateDisabilityType(String? val) =>
      emit(state.copyWith(selectedDisabilityType: val));

  void updateBirthDate(String? val) => emit(state.copyWith(birthDate: val));

  void updateNationalIdIssueDate(String? val) =>
      emit(state.copyWith(nationalIdIssueDate: val));

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

  void updateHasDisability(bool? val) {
    emit(state.copyWith(hasDisability: val));
    if (val == false) {
      emit(state.copyWith(selectedDisabilityType: null));
      disabilityTypeDetailsController.text = '';
    }
  }

  // Validation (simple: require name, birth date, national id, mobile)
  void validateRequiredFields() {
    final bool isValid = fullNameController.text.trim().isNotEmpty &&
        state.birthDate != null &&
        nationalIdController.text.trim().isNotEmpty;

    emit(state.copyWith(isFormValidated: isValid));
  }

  // Called by UI when fields change (you can call selectively too)
  void onAnyFieldChanged() {
    validateRequiredFields();
  }

  // Dummy submit (simulate network) — will set loading -> success (or failure)
  Future<void> submitEssentialData() async {
    // Before submit validate one more time
    validateRequiredFields();
    if (!state.isFormValidated) {
      emit(state.copyWith(
          submissionStatus: RequestStatus.failure,
          message: 'برجاء إكمال الحقول المطلوبة'));
      return;
    }

    emit(state.copyWith(submissionStatus: RequestStatus.loading));

    try {
      // simulate network delay
      await Future.delayed(const Duration(seconds: 1, milliseconds: 200));

      // assemble payload (for debugging / future integration)
      final payload = {
        'fullName': fullNameController.text.trim(),
        'birthDate': state.birthDate,
        'gender': state.selectedGender,
        'nationalId': nationalIdController.text.trim(),
        'nationality': state.selectedNationality,
        'maritalStatus': state.selectedMaritalStatus,
        'email': emailController.text.trim(),
        'hasInsurance': state.hasMedicalInsurance,
        'hasDisability': state.hasDisability,
        'disabilityType': state.selectedDisabilityType,
        'disabilityDetails': disabilityTypeDetailsController.text.trim(),
        'hasChronicConditions': state.hasChronicConditions,
        'employmentStatus': state.selectedEmploymentStatus,
      };

      // For now: print payload and emit success
      // ignore: avoid_print
      print('EssentialData payload: $payload');

      emit(state.copyWith(
        submissionStatus: RequestStatus.success,
        message: 'تم حفظ البيانات بنجاح',
      ));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: RequestStatus.failure,
        message: e.toString(),
      ));
    } finally {
      // reset loading after short delay so UI can show status
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(submissionStatus: RequestStatus.success));
    }
  }

  @override
  Future<void> close() async {
    // dispose controllers
    fullNameController.dispose();
    nationalIdController.dispose();
    emailController.dispose();

    disabilityTypeDetailsController.dispose();
    additionalInsuranceConditionsController.dispose();
    familyDoctorNameController.dispose();
    numberOfChildrenController.dispose();
    mainEmergencyPhoneController.dispose();
    anotherEmergencyPhoneController.dispose();

    return super.close();
  }
}
