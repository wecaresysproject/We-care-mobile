import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_essential_data_request_body_model.dart';
import 'package:we_care/features/eyes/data/repos/glasses_data_entry_repo.dart';

part 'glasses_data_entry_state.dart';

class GlassesDataEntryCubit extends Cubit<GlassesDataEntryState> {
  GlassesDataEntryCubit(this._glassesDataEntryRepo)
      : super(
          GlassesDataEntryState.initialState(),
        );
  final GlassesDataEntryRepo _glassesDataEntryRepo;
  final personalNotesController = TextEditingController();
  final suergeryDescriptionController = TextEditingController(); // وصف اضافي
  final postSurgeryInstructions = TextEditingController();

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

  // void updateSelectedHospitalCenter(String? selectedHospital) {
  //   emit(state.copyWith(selectedHospitalCenter: selectedHospital));
  // }

  void updateSelectedDoctor(String? val) {
    emit(state.copyWith(doctorName: val));
  }

  void updateSelectedHospital(String? val) {
    emit(state.copyWith(selectedHospitalCenter: val));
  }

  // void updateSelectedSurgeonName(String? surgeonName) {
  //   emit(state.copyWith(surgeonName: surgeonName));
  // }

  // void updateSelectedCountry(String? selectedCountry) {
  //   emit(state.copyWith(selectedCountryName: selectedCountry));
  // }

  // void updateSurgeryBodyPart(String? bodyPart) {
  //   emit(state.copyWith(surgeryBodyPartSelection: bodyPart));
  //   validateRequiredFields();
  //   emitGetAllSubSurgeriesRegions(selectedRegion: bodyPart!);
  // }

  // Future<void> updateSurgeryName(String? name) async {
  //   emit(state.copyWith(surgeryNameSelection: name));
  //   validateRequiredFields();
  //   await emitGetAllTechUsed();
  // }

  // void updateSurgeryStatus(String? bodyPart) {
  //   emit(state.copyWith(selectedSurgeryStatus: bodyPart));
  // }

  // Future<void> updateSelectedTechUsed(String? val) async {
  //   emit(state.copyWith(selectedTechUsed: val));
  //   await emitSurgeryPurpose();
  //   validateRequiredFields();
  // }

  // Future<void> updateSelectedSubSurgery(String? value) async {
  //   emit(state.copyWith(selectedSubSurgery: value));
  //   await emitSurgeryNamesBasedOnRegion(
  //     region: state.surgeryBodyPartSelection!,
  //     subRegion: value!,
  //   );
  //   validateRequiredFields();
  // }

  // Future<void> intialRequestsForDataEntry() async {
  //   await emitGetAllSurgeriesRegions();
  //   await emitCountriesData();
  //   await emitGetSurgeryStatus();
  // }

  // Future<void> uploadReportImagePicked({required String imagePath}) async {
  //   emit(
  //     state.copyWith(
  //       surgeryUploadReportStatus: UploadReportRequestStatus.initial,
  //     ),
  //   );
  //   final response = await _surgeriesDataEntryRepo.uploadReportImage(
  //     contentType: AppStrings.contentTypeMultiPartValue,
  //     language: AppStrings.arabicLang,
  //     image: File(imagePath),
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           message: response.message,
  //           reportImageUploadedUrl: response.reportUrl,
  //           surgeryUploadReportStatus: UploadReportRequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           surgeryUploadReportStatus: UploadReportRequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> emitGetAllTechUsed() async {
  //   final response = await _surgeriesDataEntryRepo.getAllTechUsed(
  //     language: AppStrings.arabicLang,
  //     region: state.surgeryBodyPartSelection!,
  //     subRegion: state.selectedSubSurgery!,
  //     surgeryName: state.surgeryNameSelection!,
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           allTechUsed: response,
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

  Future<void> submitGlassesEssentialDataEntryEndPoint() async {
    emit(
      state.copyWith(
        glassesEssentialDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _glassesDataEntryRepo.postGlassesEssentialDataEntryEndPoint(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: EyeGlassesEssentialDataRequestBodyModel(
        examinationDate: "",
        doctorName: "",
        centerHospitalName: "",
        glassesShop: "",
        antiReflection: true,
        blueLightProtection: true,
        scratchResistance: true,
        antiFingerprintCoating: true,
        antiFogCoating: true,
        uvProtection: true,
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

  // Future<void> emitSurgeryNamesBasedOnRegion(
  //     {required String region, required String subRegion}) async {
  //   final response = await _surgeriesDataEntryRepo.getSurgeryNamesBasedOnRegion(
  //     language: AppStrings.arabicLang,
  //     region: region,
  //     subRegion: subRegion,
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           surgeryNames: response,
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

  // Future<void> emitGetAllSurgeriesRegions() async {
  //   final response = await _surgeriesDataEntryRepo.getAllSurgeriesRegions(
  //     language: AppStrings.arabicLang,
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           bodyParts: response,
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

  // Future<void> emitCountriesData() async {
  //   final response = await _surgeriesDataEntryRepo.getCountriesData(
  //     language: AppStrings.arabicLang,
  //   );

  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           countriesNames: response.map((e) => e.name).toList(),
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

  // Future<void> emitSurgeryPurpose() async {
  //   final response = await _surgeriesDataEntryRepo.getSurgeryPurpose(
  //     language: AppStrings.arabicLang,
  //     region: state.surgeryBodyPartSelection!,
  //     subRegion: state.selectedSubSurgery!,
  //     surgeryName: state.surgeryNameSelection!,
  //     techUsed: state.selectedTechUsed!,
  //   );

  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           surgeryPurpose: response,
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

  // Future<void> postModuleData(S locale) async {
  //   final response = await _surgeriesDataEntryRepo.postModuleData(
  //     language: AppStrings.arabicLang,
  //     requestBody: SurgeryRequestBodyModel(
  //       surgeryDate: state.surgeryDateSelection!,
  //       surgeryName: state.surgeryNameSelection!,
  //       surgeryRegion: state.surgeryBodyPartSelection!,
  //       subSurgeryRegion: state.selectedSubSurgery!,
  //       usedTechnique: state.selectedTechUsed!,
  //       surgeryDescription: suergeryDescriptionController.text.isEmpty
  //           ? locale.no_data_entered
  //           : suergeryDescriptionController.text,
  //       medicalReportImage:
  //           state.reportImageUploadedUrl ?? locale.no_data_entered,
  //       surgeryStatus: state.selectedSurgeryStatus ?? locale.no_data_entered,
  //       hospitalCenter: state.selectedHospitalCenter ?? locale.no_data_entered,
  //       surgeonName: state.surgeryNameSelection ?? locale.no_data_entered,
  //       anesthesiologistName: state.internistName ?? locale.no_data_entered,
  //       postSurgeryInstructions: suergeryDescriptionController.text.isEmpty
  //           ? locale.no_data_entered
  //           : suergeryDescriptionController.text,
  //       country: state.selectedCountryName ?? locale.no_data_entered,
  //       additionalNotes: personalNotesController.text.isEmpty
  //           ? locale.no_data_entered
  //           : personalNotesController.text,
  //     ),
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           message: response,
  //           surgeriesDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           surgeriesDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    suergeryDescriptionController.dispose();
    postSurgeryInstructions.dispose();
    return super.close();
  }
}
