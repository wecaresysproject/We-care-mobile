import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';
import 'package:we_care/features/chronic_disease/data/repos/chronic_disease_data_entry_repo.dart';
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

  Future<void> emitDoctorNames() async {
    final response = await dataEntryRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            doctorNames: response,
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

  Future<void> submitEditsForChronicDisease() async {
    emit(
      state.copyWith(
        chronicDiseaseDataEntryStatus: RequestStatus.loading,
      ),
    );
    //!because i pass all edited data to loadAnalysisDataForEditing method at begining of my cubit in case i have an model to edit
    final response = await dataEntryRepo.updateChronicDiseaseDocDetailsById(
      requestBody: PostChronicDiseaseModel(
        diagnosisStartDate: state.diagnosisStartDate!,
        diseaseName: state.chronicDiseaseName!,
        medications: state.addedNewMedicines,
        treatingDoctorName: state.doctorNameSelection!,
        diseaseStatus: state.diseaseStatus!,
        sideEffect: sideEffectsController.text,
        personalNotes: personalNotesController.text,
      ),
      documentId: state.documentId,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            chronicDiseaseDataEntryStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            chronicDiseaseDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> loadChronicDiseaseDataForEditing(
      PostChronicDiseaseModel editModel, String documentId) async {
    emit(
      state.copyWith(
        isEditMode: true,
        diagnosisStartDate: editModel.diagnosisStartDate,
        chronicDiseaseName: editModel.diseaseName,
        addedNewMedicines: editModel.medications,
        doctorNameSelection: editModel.treatingDoctorName,
        diseaseStatus: editModel.diseaseStatus,
        chronincDiseaseEditedModel: editModel,
        documentId: documentId,
      ),
    );
    personalNotesController.text =
        editModel.personalNotes.isNotEmpty ? editModel.personalNotes : '--';
    sideEffectsController.text =
        editModel.sideEffect.isNotEmpty ? editModel.sideEffect : '--';
    validateRequiredFields();
    await intialRequests();
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequests() async {
    await getChronicDiseasesNames();
    await emitDoctorNames();
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
