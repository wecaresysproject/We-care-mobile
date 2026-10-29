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
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'medical_specialty_state.dart';

class MedicalSpecialtyCubit extends Cubit<MedicalSpecialtyState>
    with SafeEmitMixin<MedicalSpecialtyState> {
  MedicalSpecialtyCubit(this._sharedRepo, this._medicalSpecialtyRepo)
      : super(MedicalSpecialtyState.initial()) {
    subSpecialtyController.addListener(_updateHasChanges);
    clinicalInterestsController.addListener(_updateHasChanges);
  }

  final AppSharedRepo _sharedRepo;
  final MedicalSpecialtyRepo _medicalSpecialtyRepo;

  final formKey = GlobalKey<FormState>();
  final _changesTracker = ProfileFormChangesTracker();

  final subSpecialtyController = TextEditingController();
  final clinicalInterestsController = TextEditingController();

  /// Loads the specialties options and the doctor's saved data together.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    await Future.wait([emitSpecialtiesData(), _loadSavedMedicalSpecialty()]);
  }

  Future<void> _loadSavedMedicalSpecialty() async {
    final response = await _medicalSpecialtyRepo.getMedicalSpecialty();
    response.when(
      success: (model) {
        if (model == null) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        subSpecialtyController.text = model.subSpecialty;
        clinicalInterestsController.text = model.clinicalInterests;
        final selectedMainSpecialty =
            model.mainSpecialty.isEmpty ? null : model.mainSpecialty;
        _changesTracker.setBaseline(
          _buildRequestBody(selectedMainSpecialty).toJson(),
        );
        safeEmit(state.copyWith(
          selectedMainSpecialty: selectedMainSpecialty,
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

  MedicalSpecialtyRequestBodyModel _buildRequestBody(
    String? selectedMainSpecialty,
  ) =>
      MedicalSpecialtyRequestBodyModel(
        mainSpecialty: selectedMainSpecialty ?? '',
        subSpecialty: subSpecialtyController.text.trim(),
        clinicalInterests: clinicalInterestsController.text.trim(),
      );

  void _updateHasChanges() {
    final hasChanges = _changesTracker.hasChanges(
      _buildRequestBody(state.selectedMainSpecialty).toJson(),
    );
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
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

  void updateMainSpecialty(String? val) {
    safeEmit(state.copyWith(selectedMainSpecialty: val));
    _updateHasChanges();
  }

  Future<void> submitMedicalSpecialty() async {
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = _buildRequestBody(state.selectedMainSpecialty);

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
