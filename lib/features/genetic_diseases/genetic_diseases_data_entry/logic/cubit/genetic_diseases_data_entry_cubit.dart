import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genetic_diseases_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_members_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

class GeneticDiseasesDataEntryCubit
    extends Cubit<GeneticDiseasesDataEntryState> {
  GeneticDiseasesDataEntryCubit(this._geneticDiseasesDataEntryRepo)
      : super(
          GeneticDiseasesDataEntryState.initialState(),
        );
  final TextEditingController noOfBrothers =
      TextEditingController(); // عدد الإخوة
  final TextEditingController noOfSisters =
      TextEditingController(); // عدد الأخوات
  final TextEditingController noOfUncles =
      TextEditingController(); // عدد الأعمام
  final TextEditingController noOfAunts =
      TextEditingController(); // عدد العمّات
  final TextEditingController noOfMaternalUncles =
      TextEditingController(); // عدد الأخوال
  final TextEditingController noOfMaternalAunts =
      TextEditingController(); // عدد الخالات

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

  // Future<void> loadGeneticDiseasesForEditing(
  //   model.DetailedComplaintModel emergencyComplaint,
  //   S locale,
  // ) async {
  //   await storeTemporaryGeneticDiseasesForFamilyMember(
  //     emergencyComplaint.mainSymptoms,
  //   );

  //   emit(
  //     state.copyWith(
  //       isEditMode: true,
  //       updatedDocumentId: emergencyComplaint.id,
  //     ),
  //   );
  // }

  Future<void> storeTemporaryGeneticDiseasesForFamilyMember(
    List<NewGeneticDiseaseModel> geneticDiseases,
  ) async {
    final genticDiseasesBox =
        Hive.box<NewGeneticDiseaseModel>("medical_genetic_diseases");

    // Loop through the list and store each disease in the box
    for (var oldDisease in geneticDiseases) {
      await genticDiseasesBox.add(oldDisease);
    }
  }

  Future<void> postGenticDiseaseForFamilyMember({
    required String familyMemberName,
    required String memberCode,
  }) async {
    emit(
      state.copyWith(
        submitMemberGeneticDiseaseDetailsStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _geneticDiseasesDataEntryRepo.postGenticDiseaseForFamilyMember(
      requestBody: FamilyMemberGeneticDiseasesRequestBodyModel(
        name: familyMemberName,
        code: memberCode,
        geneticDiseases: state.geneticDiseases,
      ),
    );

    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            submitMemberGeneticDiseaseDetailsStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            submitMemberGeneticDiseaseDetailsStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  void onNumberOfBrothersChanged(String? value) {
    emit(state.copyWith(noOfBrothers: value));
  }

  void onNumberOfSistersChanged(String? value) {
    emit(state.copyWith(noOfSisters: value));
  }

  void onNumberOfUnclesChanged(String? value) {
    emit(state.copyWith(noOfUncles: value));
  }

  void onNumberOfAuntsChanged(String? value) {
    emit(state.copyWith(noOfAunts: value));
  }

  void onNumberOfMaternalUnclesChanged(String? value) {
    emit(state.copyWith(noOfMaternalUncles: value));
  }

  void onNumberOfMaternalAuntsChanged(String? value) {
    emit(state.copyWith(noOfMaternalAunts: value));
  }

  void updateSelectedHospitalName(String? value) {
    emit(state.copyWith(selectedHospital: value));
  }

  void updateSelectedCountry(String? value) {
    emit(state.copyWith(selectedCountryName: value));
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

  Future<void> editNoOfFamilyMembers() async {
    emit(
      state.copyWith(
        submitFamilyMemebersNumberStatus: RequestStatus.loading,
      ),
    );
    final response = await _geneticDiseasesDataEntryRepo.editNoOfFamilyMembers(
      requestBody: FamilyMembersModel(
        numberOfBrothers: state.noOfBrothers.toInt,
        numberOfSisters: state.noOfSisters.toInt,
        numberOfFatherSideUncles: state.noOfUncles.toInt,
        numberOfFatherSideAunts: state.noOfAunts.toInt,
        numberOfMotherSideUncles: state.noOfMaternalUncles.toInt,
        numberOfMotherSideAunts: state.noOfMaternalAunts.toInt,
      ),
    );
    response.when(
      success: (result) {
        emit(
          state.copyWith(
            message: result,
            submitFamilyMemebersNumberStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            submitFamilyMemebersNumberStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getFamilyMembersNumbers() async {
    final response =
        await _geneticDiseasesDataEntryRepo.getFamilyMembersNumbers(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (result) {
        emit(
          state.copyWith(
            familyMembersCount: result,
            noOfBrothers: result.bro.toString(),
            noOfSisters: result.sis.toString(),
            noOfUncles: result.fatherSideUncle.toString(),
            noOfAunts: result.fatherSideAunt.toString(),
            noOfMaternalUncles: result.motherSideUncle.toString(),
            noOfMaternalAunts: result.motherSideAunt.toString(),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(message: error.errors.first),
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

  Future<void> submitPersonalGeneticDiseaseDataEntry(S locale) async {
    emit(
      state.copyWith(
        geneticDiseaseDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _geneticDiseasesDataEntryRepo.submitPersonalGeneticDiseaseRequest(
      requestBody: PersonalGeneticDiseaseRequestBodyModel(
        date: state.diagnosisDate!,
        diseaseCategory: state.geneticDiseaseCategory!,
        diseaseStatus: state.selectedDiseaseStatus!,
        geneticDisease: state.selectedDiseaseName!,
        doctor: state.selectedDoctorName ?? locale.no_data_entered,
        firstUploadedImage:
            state.firstImageUploadedUrl ?? locale.no_data_entered,
        secondUploadedImage:
            state.secondImageUploadedUrl ?? locale.no_data_entered,
        medicalReport: state.reportUploadedUrl ?? locale.no_data_entered,
        hospital: state.selectedHospital ?? locale.no_data_entered,
        country: state.selectedCountryName ?? locale.no_data_entered,
      ),
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            geneticDiseaseDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            geneticDiseaseDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

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
    noOfBrothers.dispose();
    noOfSisters.dispose();
    noOfUncles.dispose();
    noOfAunts.dispose();
    noOfMaternalUncles.dispose();
    noOfMaternalAunts.dispose();
    return super.close();
  }
}
