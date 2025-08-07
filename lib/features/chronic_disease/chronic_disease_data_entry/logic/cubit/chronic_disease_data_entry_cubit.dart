import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/chronic_disease/data/repos/chronic_disease_data_entry_repo.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';

part 'chronic_disease_data_entry_state.dart';

class ChronicDiseaseDataEntryCubit extends Cubit<ChronicDiseaseDataEntryState> {
  ChronicDiseaseDataEntryCubit(this.dataEntryRepo)
      : super(
          ChronicDiseaseDataEntryState.initialState(),
        );
  final ChronicDiseaseDataEntryRepo dataEntryRepo;
  final personalNotesController = TextEditingController();
  final symptomsAccompanyingComplaintController =
      TextEditingController(); // الاعراض المصاحبة للشكوى

  final formKey = GlobalKey<FormState>();

  /// Update Field Values
  void updateDiagnosisStartDate(String? date) {
    emit(state.copyWith(diagnosisStartDate: date));
    validateRequiredFields();
  }

  void updateDoctorName(String? doctorName) {
    emit(state.copyWith(doctorNameSelection: doctorName));
  }

  void updateChronicDisease(String? val) {
    emit(state.copyWith(chronicDiseaseName: val));
    validateRequiredFields();
  }

  void updateDiseaseStatus(String? val) {
    emit(
      state.copyWith(
        diseaseStatus: val,
      ),
    );
    validateRequiredFields();
  }

  void updateSelectedMedication(String? val) {
    emit(
      state.copyWith(
        selectedMedicationName: val,
      ),
    );
  }

  // Future<void> submitEditsOnPrescription() async {
  //   emit(
  //     state.copyWith(
  //       preceriptionDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   //!because i pass all edited data to loadAnalysisDataForEditing method at begining of my cubit in case i have an model to edit
  //   final response = await dataEntryRepo.updatePrescriptionDocumentDetails(
  //     requestBody: PrescriptionRequestBodyModel(
  //       userType: UserTypes.patient.name.firstLetterToUpperCase,
  //       language: AppStrings.arabicLang, //TODO: to change later
  //       prescriptionDate: state.diagnosisStartDate!,
  //       doctorName: state.doctorNameSelection!,
  //       chronicDiseaseName: state.chronicDiseaseName!,
  //       cause: symptomsAccompanyingComplaintController.text,
  //       disease: state.selectedDisease!,
  //       preDescriptionPhoto: state.prescriptionPictureUploadedUrl,
  //       country: state.selectedCountryName!,
  //       governate: state.selectedCityName!,
  //       preDescriptionNotes: personalNotesController.text,
  //     ),
  //     documentId: state.prescribtionEditedModel!.id,
  //   );

  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           preceriptionDataEntryStatus: RequestStatus.success,
  //           message: response,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           preceriptionDataEntryStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> loadPrescriptionDataForEditing(
  //     PrescriptionModel editingPrescriptionDetailsData) async {
  //   emit(
  //     state.copyWith(
  //       diagnosisStartDate: editingPrescriptionDetailsData.preDescriptionDate,
  //       isEditMode: true,
  //       doctorNameSelection: editingPrescriptionDetailsData.doctorName,
  //       doctorSpecialitySelection:
  //           editingPrescriptionDetailsData.doctorSpecialty,
  //       selectedCountryName: editingPrescriptionDetailsData.country,
  //       selectedCityName: editingPrescriptionDetailsData.governate, //TODO:
  //       selectedDisease: editingPrescriptionDetailsData.disease,
  //       prescriptionPictureUploadedUrl:
  //           editingPrescriptionDetailsData.preDescriptionPhoto,
  //       prescriptionImageRequestStatus: UploadImageRequestStatus.success,
  //       isPrescriptionPictureSelected: true,
  //       prescribtionEditedModel: editingPrescriptionDetailsData,
  //     ),
  //   );
  //   personalNotesController.text =
  //       editingPrescriptionDetailsData.preDescriptionNotes;
  //   symptomsAccompanyingComplaintController.text =
  //       editingPrescriptionDetailsData.cause;
  //   validateRequiredFields();
  //   await intialRequestsForPrescriptionDataEntry();
  // }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForPrescriptionDataEntry() async {
    await emitCountriesData();
  }

  Future<void> emitCitiesData() async {
    final response = await dataEntryRepo.getCitiesBasedOnCountryName(
      language: AppStrings.arabicLang,
      cityName: state.selectedCountryName ?? "egypt",
    );

    response.when(
      success: (citiesList) {
        emit(
          state.copyWith(
            citiesNames: citiesList,
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

  // Future<void> postPrescriptionDataEntry(S localozation) async {
  //   emit(
  //     state.copyWith(
  //       preceriptionDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await dataEntryRepo.postPrescriptionDataEntry(
  //     PrescriptionRequestBodyModel(
  //       prescriptionDate: state.diagnosisStartDate!,

  //       userType: UserTypes.patient.name.firstLetterToUpperCase,
  //       language: AppStrings.arabicLang,
  //       doctorName: state.doctorNameSelection!, // TODO: handle it later
  //       country: state.selectedCountryName ?? localozation.no_data_entered,

  //       cause: symptomsAccompanyingComplaintController.text.isNotEmpty
  //           ? symptomsAccompanyingComplaintController.text
  //           : localozation.no_data_entered,
  //       disease: state.selectedDisease ?? localozation.no_data_entered,
  //       preDescriptionPhoto: state.prescriptionPictureUploadedUrl.isNotEmpty
  //           ? state.prescriptionPictureUploadedUrl
  //           : localozation.no_data_entered,
  //       governate: state.selectedCityName ?? localozation.no_data_entered,
  //       preDescriptionNotes: personalNotesController.text.isNotEmpty
  //           ? personalNotesController.text
  //           : localozation.no_data_entered,
  //       doctorSpecialty:
  //           state.chronicDiseaseName ?? localozation.no_data_entered,
  //     ),
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           message: successMessage,
  //           preceriptionDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           preceriptionDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> emitCountriesData() async {
    final response = await dataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response.map((e) => e.name).toList(),
          ),
        );
        emitCitiesData();
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

  void updatePrescriptionPicture(bool? isImagePicked) {
    emit(state.copyWith(isPrescriptionPictureSelected: isImagePicked));
    validateRequiredFields();
  }

  void validateRequiredFields() {
    if (state.diagnosisStartDate == null ||
        state.chronicDiseaseName == null ||
        state.diseaseStatus == null) {
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
    symptomsAccompanyingComplaintController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
