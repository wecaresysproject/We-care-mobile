import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/doctor/medical_specialty/data/models/medical_specialty_request_body_model.dart';
import 'package:we_care/features/doctor/medical_specialty/data/repos/medical_specialty_repo.dart';

part 'medical_specialty_state.dart';

class MedicalSpecialtyCubit extends Cubit<MedicalSpecialtyState>
    with SafeEmitMixin<MedicalSpecialtyState> {
  MedicalSpecialtyCubit(this._sharedRepo, this._medicalSpecialtyRepo)
      : super(MedicalSpecialtyState.initial());

  final AppSharedRepo _sharedRepo;
  final MedicalSpecialtyRepo _medicalSpecialtyRepo;

  final formKey = GlobalKey<FormState>();

  final subSpecialtyController = TextEditingController();
  final clinicalInterestsController = TextEditingController();

  Future<void> loadInitialData() async {
    await emitSpecialtiesData();
  }

  Future<void> emitSpecialtiesData() async {
    final response = await _sharedRepo.getDoctorsSpecializations(
      language: AppStrings.arabicLang,
      userType: UserTypes.doctor.name.firstLetterToUpperCase,
    );
    response.when(
      success: (specialties) =>
          safeEmit(state.copyWith(mainSpecialties: specialties)),
      failure: (error) => safeEmit(state.copyWith(message: error.errors.first)),
    );
  }

  void updateMainSpecialty(String? val) =>
      safeEmit(state.copyWith(selectedMainSpecialty: val));

  Future<void> submitMedicalSpecialty() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = MedicalSpecialtyRequestBodyModel(
      mainSpecialty: state.selectedMainSpecialty ?? '',
      subSpecialty: subSpecialtyController.text.trim(),
      clinicalInterests: clinicalInterestsController.text.trim(),
    );

    final response = await _medicalSpecialtyRepo.submitMedicalSpecialty(model);
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
    subSpecialtyController.dispose();
    clinicalInterestsController.dispose();
    return super.close();
  }
}
