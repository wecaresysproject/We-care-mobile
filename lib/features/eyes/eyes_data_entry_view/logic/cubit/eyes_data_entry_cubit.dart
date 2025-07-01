import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/eyes/data/models/eye_data_entry_request_body_model.dart';
import 'package:we_care/features/eyes/data/models/eye_part_syptoms_and_procedures_response_model.dart';
import 'package:we_care/features/eyes/data/repos/eyes_data_entry_repo.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';
import 'package:we_care/generated/l10n.dart';

part 'eyes_data_entry_state.dart';

class EyesDataEntryCubit extends Cubit<EyesDataEntryState> {
  EyesDataEntryCubit(this._eyesDataEntryRepo)
      : super(
          EyesDataEntryState.initialState(),
        );
  final EyesDataEntryRepo _eyesDataEntryRepo;
  final personalNotesController = TextEditingController();

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

  void updateSymptomDuration(String? val) {
    emit(state.copyWith(symptomDuration: val));
  }

  void updateSyptomStartDate(String? val) {
    emit(state.copyWith(syptomStartDate: val));
    validateRequiredFields();
  }

  void updateSelectedDoctorName(String? val) {
    emit(state.copyWith(doctorName: val));
  }

  void updateSelectedHospitalName(String? val) {
    emit(state.copyWith(selectedHospitalCenter: val));
  }

  getInitialRequests() {
    emitCountriesData();
  }

  void updateSelectedCountry(String? selectedCountry) {
    emit(state.copyWith(selectedCountryName: selectedCountry));
  }

  void updateProcedureDate(String? val) {
    emit(state.copyWith(procedureDateSelection: val));
  }

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

  Future<String> getEyePartDescribtion({
    required String selectedEyePart,
  }) async {
    final response = await _eyesDataEntryRepo.getEyePartDescribtion(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      selectedEyePart: selectedEyePart,
    );

    return response.when(
      success: (response) {
        return response;
      },
      failure: (error) {
        return error.errors.first;
      },
    );
  }

  Future<void> uploadReportImagePicked({required String imagePath}) async {
    emit(
      state.copyWith(
        uploadReportStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _eyesDataEntryRepo.uploadReportImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            reportImageUploadedUrl: response.reportUrl,
            uploadReportStatus: UploadReportRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            uploadReportStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> uploadMedicalExaminationImage(
      {required String imagePath}) async {
    emit(
      state.copyWith(
        uploadMedicalExaminationStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _eyesDataEntryRepo.uploadMedicalExaminationImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            medicalExaminationImageUploadedUrl: response.imageUrl,
            uploadMedicalExaminationStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            uploadMedicalExaminationStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getEyePartSyptomsAndProcedures(
      {required String selectedEyePart}) async {
    final response = await _eyesDataEntryRepo.getEyePartSyptomsAndProcedures(
      language: AppStrings.arabicLang,
      selectedEyePart: selectedEyePart,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (eyePartSyptomsAndProcedures) {
        emit(
          state.copyWith(
            eyePartSyptomsAndProcedures: eyePartSyptomsAndProcedures,
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

  Future<void> postEyeDataEntry(
    S locale, {
    required List<SymptomAndProcedureItem> symptoms,
    required List<SymptomAndProcedureItem> procedures,
    required String affectedEyePart,
  }) async {
    emit(
      state.copyWith(
        eyeDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _eyesDataEntryRepo.postEyeDataEntry(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: EyeDataEntryRequestBody(
        affectedEyePart: affectedEyePart,
        symptomStartDate: state.syptomStartDate!,
        centerHospitalName:
            state.selectedHospitalCenter ?? locale.no_data_entered,
        country: state.selectedCountryName ?? locale.no_data_entered,
        symptoms: symptoms.map((e) => e.title).toList().isEmpty
            ? [locale.no_data_entered]
            : symptoms.map((e) => e.title).toList(),
        symptomDuration: state.symptomDuration ?? locale.no_data_entered,
        medicalProcedures: procedures.map((e) => e.title).toList().isEmpty
            ? [locale.no_data_entered]
            : procedures.map((e) => e.title).toList(),
        medicalReportDate:
            state.procedureDateSelection ?? locale.no_data_entered,
        medicalReportUrl:
            state.reportImageUploadedUrl ?? locale.no_data_entered,
        medicalExaminationImages:
            state.medicalExaminationImageUploadedUrl ?? locale.no_data_entered,
        doctorName: state.doctorName ?? locale.no_data_entered,
        additionalNotes: personalNotesController.text.isEmpty
            ? '--'
            : personalNotesController.text,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            eyeDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            eyeDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  // Future<void> submitUpdatedSurgery() async {
  //   emit(
  //     state.copyWith(
  //       surgeriesDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _surgeriesDataEntryRepo.updateSurgeryDocumentById(
  //     langauge: AppStrings.arabicLang,
  //     requestBody: SurgeryRequestBodyModel(
  //       surgeryDate: state.surgeryDateSelection!,
  //       surgeryRegion: state.surgeryBodyPartSelection!,
  //       subSurgeryRegion: state.selectedSubSurgery!,
  //       surgeryName: state.surgeryNameSelection!,
  //       usedTechnique: state.selectedTechUsed!,
  //       additionalNotes: personalNotesController.text,
  //       surgeryDescription: suergeryDescriptionController.text,
  //       postSurgeryInstructions: postSurgeryInstructions.text,
  //       surgeryStatus: state.selectedSurgeryStatus!,
  //       hospitalCenter: state.selectedHospitalCenter!,
  //       anesthesiologistName: state.internistName!,
  //       country: state.selectedCountryName!,
  //       surgeonName: state.surgeonName!,
  //       medicalReportImage: state.reportImageUploadedUrl!,
  //     ),
  //     id: state.updatedSurgeryId,
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           surgeriesDataEntryStatus: RequestStatus.success,
  //           message: successMessage,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           surgeriesDataEntryStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

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

  Future<void> emitCountriesData() async {
    final response = await _eyesDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (countries) {
        emit(
          state.copyWith(
            countriesNames: countries,
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

  // /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.syptomStartDate == null) {
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
    return super.close();
  }
}
