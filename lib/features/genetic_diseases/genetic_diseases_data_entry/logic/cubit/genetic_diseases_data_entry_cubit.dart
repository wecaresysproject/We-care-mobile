import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class PersonalGeneticDiseasesDataEntryCubit
    extends Cubit<PersonalGeneticDiseasesDataEntryState> {
  PersonalGeneticDiseasesDataEntryCubit(this._geneticDiseasesDataEntryRepo)
      : super(
          PersonalGeneticDiseasesDataEntryState.initialState(),
        );

  final GeneticDiseasesDataEntryRepo _geneticDiseasesDataEntryRepo;
  List<NewGeneticDiseaseModel> geneticDiseases = [];
  Future<void> fetchAllAddedGeneticDiseases() async {
    try {
      final geneticDiseasesBox =
          Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");
      geneticDiseases = geneticDiseasesBox.values.toList(growable: true);
      emit(
        state.copyWith(
          geneticDiseases: geneticDiseases,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          geneticDiseases: [],
          message: e.toString(),
        ),
      );
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

  Future<void> getGeneticDiseasesBasedOnClassification() async {
    final response = await _geneticDiseasesDataEntryRepo
        .getGeneticDiseasesBasedOnClassification(
      language: AppStrings.arabicLang,
      diseaseClassification: state.geneticDiseaseCategory ?? "",
    );

    response.when(
      success: (statues) {
        emit(
          state.copyWith(
            diseasesNames: statues,
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

  Future<void> removeAddedGeneticDisease(int index) async {
    final Box<NewGeneticDiseaseModel> geneticDiseasesBox =
        Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");

    if (index >= 0 && index < geneticDiseasesBox.length) {
      await geneticDiseasesBox.deleteAt(index);
    }
  }
  // Future<void> loadMedicinesDataEnteredForEditing(
  //   MedicineModel pastDataEntered,
  // ) async {
  //   await storeTempUserPastComplaints(pastDataEntered.mainSymptoms);

  //   emit(
  //     state.copyWith(
  //       medicineStartDate: pastDataEntered.startDate,
  //       selectedMedicineName: pastDataEntered.medicineName,
  //       selectedMedicalForm: pastDataEntered.usageMethod,
  //       selectedDose: pastDataEntered.dosage,
  //       selectedNoOfDose: pastDataEntered.dosageFrequency,
  //       doseDuration: pastDataEntered.usageDuration,
  //       timePeriods: pastDataEntered.timeDuration,
  //       selectedChronicDisease: pastDataEntered.chronicDiseaseMedicine,
  //       medicalComplaints: pastDataEntered.mainSymptoms,
  //       selectedDoctorName: pastDataEntered.doctorName,
  //       selectedAlarmTime: pastDataEntered.reminder,
  //       isEditMode: true,
  //       updatedDocumentId: pastDataEntered.id,
  //     ),
  //   );
  //   personalInfoController.text = pastDataEntered.personalNotes;
  //   validateRequiredFields();
  //   await initialDataEntryRequests();
  // }

  // Future<void> submitEditsForMedicine() async {
  //   emit(
  //     state.copyWith(
  //       medicinesDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response =
  //       await _medicinesDataEntryRepo.editSpecifcMedicineDataDetails(
  //     medicineId: state.updatedDocumentId,
  //     requestBody: MedicineDataEntryRequestBody(
  //       startDate: state.medicineStartDate!,
  //       medicineName: state.selectedMedicineName!,
  //       usageMethod: state.selectedMedicalForm!,
  //       dosage: state.selectedDose!,
  //       dosageFrequency: state.selectedNoOfDose!,
  //       usageDuration: state.doseDuration!,
  //       timeDuration: state.timePeriods!,
  //       chronicDiseaseMedicine: state.selectedChronicDisease!,
  //       doctorName: state.selectedDoctorName!,
  //       reminder: state.selectedAlarmTime!,
  //       reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
  //       personalNotes: personalInfoController.text,
  //       userMedicalComplaint: state.medicalComplaints,
  //     ),
  //     language: AppStrings.arabicLang,
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //   );

  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           medicinesDataEntryStatus: RequestStatus.success,
  //           message: successMessage,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           medicinesDataEntryStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> initialDataEntryRequests() async {
    await getAllGeneticDiseasesClassfications();
    await getAllGeneticDiseasesStatus();
    await emitCountriesData();
    await emitDoctorNames();
  }

  // Future<void> postMedicinesDataEntry(S locale) async {
  //   emit(
  //     state.copyWith(
  //       medicinesDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _geneticDiseasesDataEntryRepo.postMedicinesDataEntry(
  //     userType: UserTypes.patient.name.firstLetterToUpperCase,
  //     requestBody: MedicineDataEntryRequestBody(
  //       startDate: state.medicineStartDate!,
  //       medicineName: state.selectedMedicineName!,
  //       usageMethod: state.selectedMedicalForm!,
  //       dosage: state.selectedDose!,
  //       dosageFrequency: state.selectedNoOfDose!,
  //       usageDuration: state.doseDuration!,
  //       timeDuration: state.timePeriods!,
  //       chronicDiseaseMedicine: locale.no_data_entered,
  //       doctorName: state.selectedDoctorName ?? locale.no_data_entered,
  //       reminder: state.selectedAlarmTime ?? locale.no_data_entered,
  //       reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
  //       personalNotes: "",
  //       geneticDiseases: state.geneticDiseases,
  //     ),
  //     language: AppStrings.arabicLang,
  //   );
  //   response.when(
  //     success: (successMessage) {
  //       emit(
  //         state.copyWith(
  //           message: successMessage,
  //           medicinesDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           medicinesDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  /// Update Field Values
  void updateDiagnosisDate(String? date) {
    emit(state.copyWith(diagnosisDate: date));
    validateRequiredFields();
  }

  Future<void> updateSelectedGeneticDiseaseCategory(String? val) async {
    emit(state.copyWith(geneticDiseaseCategory: val));
    await getGeneticDiseasesBasedOnClassification();
    validateRequiredFields();
  }

  Future<void> updateSelectedDiseaseStatus(String? val) async {
    emit(state.copyWith(selectedDiseaseStatus: val));
    validateRequiredFields();
  }

  Future<void> updateSelectedGeneticDiseaseName(String? val) async {
    emit(state.copyWith(selectedDiseaseName: val));
    validateRequiredFields();
  }

  void updateSelectedDoctorName(String? value) {
    emit(state.copyWith(selectedDoctorName: value));
  }

  Future<void> emitCountriesData() async {
    final response = await _geneticDiseasesDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response,
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

  Future<void> uploadFirstImagePicked({required String imagePath}) async {
    emit(
      state.copyWith(
        firstImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _geneticDiseasesDataEntryRepo.uploadFirstImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            firstImageUploadedUrl: response.imageUrl,
            firstImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            firstImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> uploadSecondImagePicked({required String imagePath}) async {
    emit(
      state.copyWith(
        secondImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _geneticDiseasesDataEntryRepo.uploadSecondImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            secondImageUploadedUrl: response.imageUrl,
            secondImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            secondImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> uploadReportImage({required String imagePath}) async {
    emit(
      state.copyWith(
        reportRequestStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _geneticDiseasesDataEntryRepo.uploadReportImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            reportRequestStatus: UploadReportRequestStatus.success,
            reportUploadedUrl: response.reportUrl,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            reportRequestStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitDoctorNames() async {
    final response = await _geneticDiseasesDataEntryRepo.getAllDoctors(
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

  void validateRequiredFields() {
    if (state.diagnosisDate == null ||
        state.geneticDiseaseCategory == null ||
        state.selectedDiseaseStatus == null ||
        state.selectedDiseaseName == null) {
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

  Future<void> clearAllAddedComplaints() async {
    try {
      final geneticDiseasesBox =
          Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");
      await geneticDiseasesBox.clear();
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
    await clearAllAddedComplaints();

    return super.close();
  }
}
