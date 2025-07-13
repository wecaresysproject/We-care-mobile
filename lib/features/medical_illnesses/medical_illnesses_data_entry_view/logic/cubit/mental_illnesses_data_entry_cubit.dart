import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/medical_illnesses/data/repos/mental_illnesses_data_entry_repo.dart';

part 'mental_illnesses_data_entry_state.dart';

class MedicalIllnessesDataEntryCubit
    extends Cubit<MedicalIllnessesDataEntryState> {
  MedicalIllnessesDataEntryCubit(this._medicalIllnessesDataEntryRepo)
      : super(
          MedicalIllnessesDataEntryState.initialState(),
        );
  final MentalIllnessesDataEntryRepo _medicalIllnessesDataEntryRepo;
  final personalNotesController = TextEditingController();

  // Future<void> loadPastEyeDataEnteredForEditing({
  //   required EyeProceduresAndSymptomsDetailsModel pastEyeData,
  //   required String id,
  // }) async {
  //   emit(
  //     state.copyWith(
  //       syptomStartDate: pastEyeData.symptomStartDate,
  //       selectedHospitalCenter: pastEyeData.centerHospitalName,
  //       selectedCountryName: pastEyeData.country,
  //       eyePartSyptomsAndProcedures: EyePartSyptomsAndProceduresResponseModel(
  //         procedures: pastEyeData.medicalProcedures,
  //         symptoms: pastEyeData.symptoms,
  //       ),
  //       symptomDuration: pastEyeData.symptomDuration,
  //       medicalExaminationImageUploadedUrl:
  //           pastEyeData.medicalExaminationImages,
  //       doctorName: pastEyeData.doctorName,
  //       isEditMode: true,
  //       editDecumentId: id,
  //       affectedEyePart: pastEyeData.affectedEyePart,
  //       reportImageUploadedUrl: pastEyeData.medicalReportUrl,
  //       procedureDateSelection: pastEyeData.medicalReportDate,
  //     ),
  //   );
  //   personalNotesController.text =
  //       pastEyeData.additionalNotes == '--' ? '' : pastEyeData.additionalNotes;

  //   validateRequiredFields();
  //   await getInitialRequests();
  // }

  void updatExaminationDate(String? val) {
    emit(state.copyWith(examinationDate: val));
    validateRequiredFields();
  }

  void updateMentalIllnessesType(String? val) {
    emit(state.copyWith(mentalIllnessesType: val));
  }

  void updateMedicalSyptoms(String? val) {
    emit(state.copyWith(selectedMedicalSyptoms: val));
  }

  // void updateSelectedDoctorName(String? val) {
  //   emit(state.copyWith(doctorName: val));
  // }

  // void updateSelectedHospitalName(String? val) {
  //   emit(state.copyWith(selectedHospitalCenter: val));
  // }

  getInitialRequests() {
    // emitCountriesData();
  }

  // void updateSelectedCountry(String? selectedCountry) {
  //   emit(state.copyWith(selectedCountryName: selectedCountry));
  // }

  void updateSelectedDiseaseIntensity(String? val) {
    emit(state.copyWith(selectedDiseaseIntensity: val));
  }

  void updateDiseaseDuration(String? val) {
    emit(state.copyWith(diseaseDuration: val));
  }

  void updateMentalHealthEmergency(String? val) {
    emit(state.copyWith(selectedMentalHealthEmergency: val));
  }

  void updateSelectedSocialSupport(String? val) {
    emit(state.copyWith(selectedsocialSupport: val));
  }

  void updateSelectedMedicationSideEffects(String? val) {
    emit(state.copyWith(selectedMedicationSideEffects: val));
  }

  void updatePreferredMentalWellnessActivities(String? val) {
    emit(state.copyWith(selectedPreferredMentalWellnessActivities: val));
  }
  // Future<String> getEyePartDescribtion({
  //   required String selectedEyePart,
  // }) async {
  //   final response = await _eyesDataEntryRepo.getEyePartDescribtion(
  //     language: AppStrings.arabicLang,
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //     selectedEyePart: selectedEyePart,
  //   );

  //   return response.when(
  //     success: (response) {
  //       return response;
  //     },
  //     failure: (error) {
  //       return error.errors.first;
  //     },
  //   );
  // }

  // Future<void> uploadReportImagePicked({required String imagePath}) async {
  //   emit(
  //     state.copyWith(
  //       uploadReportStatus: UploadReportRequestStatus.initial,
  //     ),
  //   );
  //   final response = await _eyesDataEntryRepo.uploadReportImage(
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
  //           uploadReportStatus: UploadReportRequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           uploadReportStatus: UploadReportRequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> uploadMedicalExaminationImage(
  //     {required String imagePath}) async {
  //   emit(
  //     state.copyWith(
  //       uploadMedicalExaminationStatus: UploadImageRequestStatus.initial,
  //     ),
  //   );
  //   final response = await _eyesDataEntryRepo.uploadMedicalExaminationImage(
  //     contentType: AppStrings.contentTypeMultiPartValue,
  //     language: AppStrings.arabicLang,
  //     image: File(imagePath),
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           message: response.message,
  //           medicalExaminationImageUploadedUrl: response.imageUrl,
  //           uploadMedicalExaminationStatus: UploadImageRequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           uploadMedicalExaminationStatus: UploadImageRequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> getEyePartSyptomsAndProcedures(
  //     {required String selectedEyePart}) async {
  //   final response = await _eyesDataEntryRepo.getEyePartSyptomsAndProcedures(
  //     language: AppStrings.arabicLang,
  //     selectedEyePart: selectedEyePart,
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //   );
  //   response.when(
  //     success: (eyePartSyptomsAndProcedures) {
  //       emit(
  //         state.copyWith(
  //           eyePartSyptomsAndProcedures: eyePartSyptomsAndProcedures,
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

  // Future<void> postEyeDataEntry(
  //   S locale, {
  //   required List<SymptomAndProcedureItem> symptoms,
  //   required List<SymptomAndProcedureItem> procedures,
  //   required String affectedEyePart,
  // }) async {
  //   emit(
  //     state.copyWith(
  //       eyeDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _eyesDataEntryRepo.postEyeDataEntry(
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //     requestBody: EyeDataEntryRequestBody(
  //       affectedEyePart: affectedEyePart,
  //       symptomStartDate: state.syptomStartDate!,
  //       centerHospitalName:
  //           state.selectedHospitalCenter ?? locale.no_data_entered,
  //       country: state.selectedCountryName ?? locale.no_data_entered,
  //       symptoms: symptoms.map((e) => e.title).toList().isEmpty
  //           ? [locale.no_data_entered]
  //           : symptoms.map((e) => e.title).toList(),
  //       symptomDuration: state.symptomDuration ?? locale.no_data_entered,
  //       medicalProcedures: procedures.map((e) => e.title).toList().isEmpty
  //           ? [locale.no_data_entered]
  //           : procedures.map((e) => e.title).toList(),
  //       medicalReportDate:
  //           state.procedureDateSelection ?? locale.no_data_entered,
  //       medicalReportUrl:
  //           state.reportImageUploadedUrl ?? locale.no_data_entered,
  //       medicalExaminationImages:
  //           state.medicalExaminationImageUploadedUrl ?? locale.no_data_entered,
  //       doctorName: state.doctorName ?? locale.no_data_entered,
  //       additionalNotes: personalNotesController.text.isEmpty
  //           ? '--'
  //           : personalNotesController.text,
  //     ),
  //     language: AppStrings.arabicLang,
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           message: successMessage,
  //           eyeDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           eyeDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> submitEyeDataEnteredEdits() async {
  //   emit(
  //     state.copyWith(
  //       eyeDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _eyesDataEntryRepo.editEyeDataEntered(
  //     requestBody: EyeDataEntryRequestBody(
  //       affectedEyePart: state.affectedEyePart!,
  //       symptomStartDate: state.syptomStartDate!,
  //       centerHospitalName: state.selectedHospitalCenter!,
  //       country: state.selectedCountryName!,
  //       symptoms: state.eyePartSyptomsAndProcedures!.symptoms,
  //       symptomDuration: state.symptomDuration!,
  //       medicalProcedures: state.eyePartSyptomsAndProcedures!.procedures,
  //       medicalReportDate: state.procedureDateSelection!,
  //       medicalReportUrl: state.reportImageUploadedUrl!,
  //       medicalExaminationImages: state.medicalExaminationImageUploadedUrl!,
  //       doctorName: state.doctorName!,
  //       additionalNotes: personalNotesController.text.isEmpty
  //           ? '--'
  //           : personalNotesController.text,
  //     ),
  //     id: state.editDecumentId,
  //     language: 'ar',
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           eyeDataEntryStatus: RequestStatus.success,
  //           message: successMessage,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           eyeDataEntryStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> emitCountriesData() async {
  //   final response = await _medicalIllnessesDataEntryRepo.getCountriesData(
  //     language: AppStrings.arabicLang,
  //   );

  //   response.when(
  //     success: (countries) {
  //       emit(
  //         state.copyWith(
  //           countriesNames: countries,
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

  void validateRequiredFields() {
    if (state.examinationDate == null || state.mentalIllnessesType == null) {
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

  @override
  Future<void> close() {
    personalNotesController.dispose();
    return super.close();
  }
}
