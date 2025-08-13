import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';
import 'package:we_care/features/chronic_disease/data/repos/chronic_disease_data_entry_repo.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/generated/l10n.dart';

part 'chronic_disease_data_entry_state.dart';

class ChronicDiseaseDataEntryCubit extends Cubit<ChronicDiseaseDataEntryState> {
  ChronicDiseaseDataEntryCubit(this.dataEntryRepo)
      : super(
          ChronicDiseaseDataEntryState.initialState(),
        );
  final ChronicDiseaseDataEntryRepo dataEntryRepo;
  final personalNotesController = TextEditingController();
  final sideEffectsController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  List<AddNewMedicineModel> addedNewMedicines = [];
  Future<void> fetchAllAddedMedicines() async {
    try {
      final addNewMedicineBox = Hive.box<AddNewMedicineModel>("addNewMedicine");
      addedNewMedicines = addNewMedicineBox.values.toList(growable: true);
      emit(
        state.copyWith(
          addedNewMedicines: addedNewMedicines,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          addedNewMedicines: [],
          message: e.toString(),
        ),
      );
    }
  }

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
  Future<void> intialRequests() async {
    await getChronicDiseasesNames();
  }

  Future<void> postChronicDiseaseData(S locale) async {
    emit(
      state.copyWith(
        chronicDiseaseDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await dataEntryRepo.postChronicDiseaseData(
      requestBody: PostChronicDiseaseModel(
        diagnosisStartDate: state.diagnosisStartDate!,
        diseaseName: state.chronicDiseaseName!,
        medications: state.addedNewMedicines,
        treatingDoctorName: state.doctorNameSelection ?? locale.no_data_entered,
        diseaseStatus: state.diseaseStatus!,
        sideEffect: sideEffectsController.text.isNotEmpty
            ? sideEffectsController.text
            : locale.no_data_entered,
        personalNotes: personalNotesController.text.isNotEmpty
            ? personalNotesController.text
            : locale.no_data_entered,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            chronicDiseaseDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            chronicDiseaseDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getChronicDiseasesNames() async {
    final response = await dataEntryRepo.getChronicDiseasesNames(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (diseasesList) {
        emit(
          state.copyWith(
            chronicDiseaseNames: diseasesList,
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

  Future<void> removeAddedMedicine(int index) async {
    final Box<AddNewMedicineModel> medicinesBox =
        Hive.box<AddNewMedicineModel>("addNewMedicine");

    if (index < 0 || index >= medicinesBox.length) return;

    await medicinesBox.deleteAt(index);

    final updatedMedicines = medicinesBox.values.toList();

    emit(
      state.copyWith(addedNewMedicines: updatedMedicines),
    );
  }

  Future<void> clearAllMedicines() async {
    try {
      final medicinesBox = Hive.box<AddNewMedicineModel>("addNewMedicine");
      await medicinesBox.clear();
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    personalNotesController.dispose();
    sideEffectsController.dispose();
    await clearAllMedicines();
    formKey.currentState?.reset();
    return super.close();
  }
}
