import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';

part 'create_new_genetic_disease_state.dart';

class CreateNewGenticDiseaseCubit extends Cubit<CreateNewGeneticDiseaseState> {
  CreateNewGenticDiseaseCubit(this._geneticDiseasesDataEntryRepo)
      : super(CreateNewGeneticDiseaseState.initial());
  final GeneticDiseasesDataEntryRepo _geneticDiseasesDataEntryRepo;

  Future<void> saveNewGeneticDisease() async {
    final newGeneticDisease = NewGeneticDiseaseModel(
      diseaseCategory: state.selectedDiseaseCategory,
      geneticDisease: state.selectedGeneticDisease,
      appearanceAgeStage: state.selectedAppearanceAgeStage,
      patientStatus: state.selectedPatientStatus,
    );
    final Box<NewGeneticDiseaseModel> geneticDiseasesBox =
        Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");

    await geneticDiseasesBox.add(newGeneticDisease);

    emit(
      state.copyWith(
        isNewDiseaseAddedSuccefully: true,
      ),
    );
  }

  Future<void> loadGeneticDiseaseDetailsViewForEditing(
      NewGeneticDiseaseModel geneticDisease) async {
    emit(
      state.copyWith(
        isEditingGeneticDisease: true,
        selectedGeneticDisease: geneticDisease.geneticDisease,
        selectedDiseaseCategory: geneticDisease.diseaseCategory,
        selectedAppearanceAgeStage: geneticDisease.appearanceAgeStage,
        selectedPatientStatus: geneticDisease.patientStatus,
      ),
    );
    validateRequiredFields();
    await getAllRequestsForAddingNewGeneticDiseaseView();
  }

  Future<void> updateGeneticDisease(
      int index, NewGeneticDiseaseModel oldGenticDiseaseDetails) async {
    final Box<NewGeneticDiseaseModel> geneticDiseasesBox =
        Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");

    final updatedMedicalComplaint = oldGenticDiseaseDetails.updateWith(
      diseaseCategory: state.selectedDiseaseCategory,
      geneticDisease: state.selectedGeneticDisease,
      appearanceAgeStage: state.selectedAppearanceAgeStage,
      patientStatus: state.selectedPatientStatus,
    );
    if (index >= 0 && index < geneticDiseasesBox.length) {
      await geneticDiseasesBox.put(
        index,
        updatedMedicalComplaint,
      );

      emit(
        state.copyWith(
          isEditingGeneticDiseaseSuccess: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isEditingGeneticDiseaseSuccess: false,
        ),
      );
      throw Exception("Invalid index: $index");
    }
  }

  Future<void> getAllGeneticDiseasesClassfications() async {
    final response =
        await _geneticDiseasesDataEntryRepo.getAllGeneticDiseasesClassfications(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (classifications) {
        emit(
          state.copyWith(
            diseasesClassfications: classifications,
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

  Future<void> getAllGeneticDiseasesStatus() async {
    final response =
        await _geneticDiseasesDataEntryRepo.getAllGeneticDiseasesStatus(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (statues) {
        emit(
          state.copyWith(
            diseasesStatuses: statues,
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

  Future<void> getAllRequestsForAddingNewGeneticDiseaseView() async {
    await getAllGeneticDiseasesClassfications();
    await getAllGeneticDiseasesStatus();
  }

//   Future<void> getAllComplaintsPlaces() async {
//     emit(
//       state.copyWith(
//         mainRegionComplainsLoadingState: OptionsLoadingState.loading,
//       ),
//     );
//     final response =
//         await _emergencyComplaintsDataEntryRepo.getAllPlacesOfComplaints(
//       language: AppStrings.arabicLang,
//     );
//     response.when(
//       success: (complaints) {
//         emit(
//           state.copyWith(
//             complaintPlaces: complaints,
//             mainRegionComplainsLoadingState: OptionsLoadingState.loaded,
//           ),
//         );
//       },
//       failure: (error) {
//         emit(
//           state.copyWith(
//             message: error.errors.first,
//             mainRegionComplainsLoadingState: OptionsLoadingState.error,
//           ),
//         );
//       },
//     );
//   }

// // الاعراض المرضية - الشكوى
//   Future<void> getAllRelevantComplaintsToSelectedBodyPart(
//     String selectedBodyPartName,
//   ) async {
//     final response = await _emergencyComplaintsDataEntryRepo
//         .getAllComplaintsRelevantToBodyPartName(
//       language: AppStrings.arabicLang,
//       bodyPartName: selectedBodyPartName,
//       mainArea: state.symptomsDiseaseRegion!,
//     );
//     response.when(
//       success: (complaints) {
//         emit(
//           state.copyWith(
//             releatedComplaintsToSelectedBodyPartName: complaints,
//           ),
//         );
//       },
//       failure: (error) {
//         emit(
//           state.copyWith(
//             message: error.errors.first,
//           ),
//         );
//       },
//     );
//   }

//   // الاعراض المرضية - العضو/الجزء
//   Future<void> getAllOrganOrPartSymptomsRelativeToMainRegion(
//       String selectedMainRegion) async {
//     emit(
//       state.copyWith(
//         complaintPlacesRelativeToMainRegionLoadingState:
//             OptionsLoadingState.loading,
//       ),
//     );
//     final response = await _emergencyComplaintsDataEntryRepo
//         .getAllOrganOrPartSymptomsRelativeToMainRegion(
//       language: AppStrings.arabicLang,
//       mainRegion: selectedMainRegion,
//     );
//     response.when(
//       success: (response) {
//         emit(
//           state.copyWith(
//             complaintPlacesRelativeToMainRegion: response,
//             complaintPlacesRelativeToMainRegionLoadingState:
//                 OptionsLoadingState.loaded,
//           ),
//         );
//       },
//       failure: (error) {
//         emit(
//           state.copyWith(
//             message: error.errors.first,
//             complaintPlacesRelativeToMainRegionLoadingState:
//                 OptionsLoadingState.error,
//           ),
//         );
//       },
//     );
//   }

  void validateRequiredFields() {
    if (state.selectedGeneticDisease == null ||
        state.selectedAppearanceAgeStage == null ||
        state.selectedPatientStatus == null ||
        state.selectedDiseaseCategory == null) {
      emit(
        state.copyWith(
          isFormsValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormsValidated: true,
        ),
      );
    }
  }

  void updateSelectionOfGeneticDisease(String? val) {
    emit(state.copyWith(selectedGeneticDisease: val));
    validateRequiredFields();
  }

  void updateSelectionOfGeneticDiseaseCategory(String? val) {
    emit(state.copyWith(selectedDiseaseCategory: val));
    validateRequiredFields();
  }

  void updateSelectionOfAppearanceAgeStage(String? val) {
    emit(state.copyWith(selectedAppearanceAgeStage: val));
    validateRequiredFields();
  }

  void updateSelectionOfDiseaseStatus(String? val) {
    emit(state.copyWith(selectedPatientStatus: val));
    validateRequiredFields();
  }
//   Future<void> updateSymptomsDiseaseRegion(String? symptom) async {
//     emit(state.copyWith(symptomsDiseaseRegion: symptom));
//     await getAllOrganOrPartSymptomsRelativeToMainRegion(symptom!);
//     await getAllRelevantComplaintsToSelectedBodyPart(symptom);
//     validateRequiredFields();
//   }

//   Future<void> updateSelectedOrganOrPartSymptom(String? value) async {
//     emit(state.copyWith(selectedOrganOrPartSymptom: value));
//     // await getAllRelevantComplaintsToSelectedBodyPart(symptom!);
//     validateRequiredFields();
//   }

//   void updateMedicalSymptomsIssue(String? issue) {
//     emit(state.copyWith(medicalSymptomsIssue: issue));
//     updateMainAreaAndBodyPartSymptoms(issue!);
//     validateRequiredFields();
//   }

//   void updateComplaintDegree(String? intensity) {
//     emit(state.copyWith(complaintDegree: intensity));
//     validateRequiredFields();
//   }

//   void updateMainAreaAndBodyPartSymptoms(String issueDescription) {
//     for (var element in state.bodySyptomsResults) {
//       if (element.description == issueDescription) {
//         emit(
//           state.copyWith(
//             symptomsDiseaseRegion: element.mainArea,
//             selectedOrganOrPartSymptom: element.bodyPart,
//           ),
//         );
//       }
//     }
//   }
}
