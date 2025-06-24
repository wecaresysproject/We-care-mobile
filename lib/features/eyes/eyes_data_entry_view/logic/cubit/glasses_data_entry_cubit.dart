import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_essential_data_request_body_model.dart';
import 'package:we_care/features/eyes/data/repos/glasses_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'glasses_data_entry_state.dart';

class GlassesDataEntryCubit extends Cubit<GlassesDataEntryState> {
  GlassesDataEntryCubit(this._glassesDataEntryRepo)
      : super(
          GlassesDataEntryState.initialState(),
        );
  final GlassesDataEntryRepo _glassesDataEntryRepo;

  // Future<void> loadPastSurgeryDataForEditing(SurgeryModel pastSurgery) async {
  //   emit(
  //     state.copyWith(
  //       surgeryDateSelection: pastSurgery.surgeryDate,
  //       surgeryBodyPartSelection: pastSurgery.surgeryRegion,
  //       selectedSubSurgery: pastSurgery.subSurgeryRegion,
  //       surgeryNameSelection: pastSurgery.surgeryName,
  //       selectedTechUsed: pastSurgery.usedTechnique,
  //       surgeryPurpose: pastSurgery.purpose,
  //       reportImageUploadedUrl: pastSurgery.medicalReportImage,
  //       selectedSurgeryStatus: pastSurgery.surgeryStatus,
  //       selectedHospitalCenter: pastSurgery.hospitalCenter,
  //       internistName: pastSurgery.anesthesiologistName,
  //       selectedCountryName: pastSurgery.country,
  //       surgeonName: pastSurgery.surgeonName,
  //       isEditMode: true,
  //       updatedSurgeryId: pastSurgery.id,
  //     ),
  //   );
  //   personalNotesController.text = pastSurgery.additionalNotes;
  //   suergeryDescriptionController.text = pastSurgery.surgeryDescription;
  //   postSurgeryInstructions.text = pastSurgery.postSurgeryInstructions;

  //   validateRequiredFields();
  //   await intialRequestsForDataEntry();
  // }

  /// Update Field Values
  void updateExaminationDate(String? date) {
    emit(state.copyWith(examinationDateSelection: date));
    validateRequiredFields();
  }

  void updateAntiReflection(bool? val) {
    emit(state.copyWith(antiReflection: val));
  }
  // void updateSelectedHospitalCenter(String? selectedHospital) {
  //   emit(state.copyWith(selectedHospitalCenter: selectedHospital));
  // }

  void updateSelectedDoctor(String? val) {
    emit(state.copyWith(doctorName: val));
  }

  void updateSelectedHospital(String? val) {
    emit(state.copyWith(selectedHospitalCenter: val));
  }

  void updateSelectedGlassesStore(String? val) {
    emit(state.copyWith(glassesStore: val));
  }

  void updateAntiBlueLight(bool? val) {
    emit(state.copyWith(isBlueLightProtection: val));
  }

  void updateScratchResistance(bool? val) {
    emit(state.copyWith(isScratchResistance: val));
  }

  void updateAntiFingerprint(bool? val) {
    emit(state.copyWith(isAntiFingerprint: val));
  }

  void updateAntiFogCoating(bool? val) {
    emit(state.copyWith(isAntiFogCoating: val));
  }

  void updateUVProtection(bool? val) {
    emit(state.copyWith(isUVProtection: val));
  }

  Future<void> submitGlassesEssentialDataEntryEndPoint(
      {required S locale}) async {
    emit(
      state.copyWith(
        glassesEssentialDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _glassesDataEntryRepo.postGlassesEssentialDataEntryEndPoint(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: EyeGlassesEssentialDataRequestBodyModel(
        examinationDate: state.examinationDateSelection!,
        doctorName: state.doctorName ?? locale.no_data_entered,
        centerHospitalName:
            state.selectedHospitalCenter ?? locale.no_data_entered,
        glassesShop: state.glassesStore ?? locale.no_data_entered,
        antiReflection: state.antiReflection,
        blueLightProtection: state.isBlueLightProtection,
        scratchResistance: state.isScratchResistance,
        antiFingerprintCoating: state.isAntiFingerprint,
        antiFogCoating: state.isAntiFogCoating,
        uvProtection: state.isUVProtection,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            glassesEssentialDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            glassesEssentialDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  // Future<void> emitGetSurgeryStatus() async {
  //   final response = await _surgeriesDataEntryRepo.getSurgeryStatus(
  //     language: AppStrings.arabicLang,
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           allSurgeryStatuses: response,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }
  // // المناطق العمليه الفرعيه

  // Future<void> emitGetAllSubSurgeriesRegions(
  //     {required String selectedRegion}) async {
  //   final response = await _surgeriesDataEntryRepo.getAllSubSurgeriesRegions(
  //     language: AppStrings.arabicLang,
  //     region: selectedRegion,
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           subSurgeryRegions: response,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.examinationDateSelection == null) {
      emit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }
}
