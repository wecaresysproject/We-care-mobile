import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/genetic_diseases/data/models/add_new_user_to_family_tree_request_body.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genetic_diseases_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_members_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_data_entry_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

class GeneticDiseasesDataEntryCubit
    extends Cubit<GeneticDiseasesDataEntryState> {
  GeneticDiseasesDataEntryCubit(
      this._geneticDiseasesDataEntryRepo, this.sharedRepo)
      : super(
          GeneticDiseasesDataEntryState.initialState(),
        );
  final AppSharedRepo sharedRepo;
  final reportTextController = TextEditingController();

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
      safeEmit(
        state.copyWith(
          geneticDiseases: geneticDiseases,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          geneticDiseases: [],
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> loadIntialyPersonalGeneticDiseasesForEditing(
    PersonalGeneticDiseasDetails pastGeneticDisease, {
    required String documentId,
  }) async {
    safeEmit(
      state.copyWith(
        diagnosisDate: pastGeneticDisease.date!,
        geneticDiseaseCategory: pastGeneticDisease.geneticDiseaseCategory,
        selectedDiseaseName: pastGeneticDisease.geneticDisease,
        selectedDiseaseStatus: pastGeneticDisease.diseaseStatus,
        firstImageUploadedUrls: pastGeneticDisease.geneticTestsImages,
        secondImageUploadedUrls: pastGeneticDisease.otherTestsImages,
        reportsUploadedUrls: pastGeneticDisease.medicalReport,
        selectedDoctorName: pastGeneticDisease.doctor,
        selectedHospital: pastGeneticDisease.hospital,
        selectedCountryName: pastGeneticDisease.country,
        isEditMode: true,
        updatedDocumentId: documentId,
      ),
    );
    reportTextController.text = pastGeneticDisease.writtenReport ?? "";

    validateRequiredFields();
  }

  Future<void> loadGeneticDiseasesDataEnteredForEditing(
    FamilyMemberGeneticsDiseasesResponseModel memberGeneticDiseases,
  ) async {
    final List<NewGeneticDiseaseModel> oldGeneticDiseases = [];
    for (var oldDisease in memberGeneticDiseases.geneticDiseases!) {
      oldGeneticDiseases.add(
        NewGeneticDiseaseModel(
          diseaseCategory: oldDisease.inheritanceType,
          geneticDisease: oldDisease.geneticDisease,
          appearanceAgeStage: "نسال فيها ا/اشرف ،م/ آيه",
          patientStatus: oldDisease.diseaseStatus,
        ),
      );
    }

    await storeTemporaryGeneticDiseasesForFamilyMember(
      oldGeneticDiseases,
    );

    safeEmit(
      state.copyWith(
        isEditMode: true,
        geneticDiseases: oldGeneticDiseases,
        familyMemberName: memberGeneticDiseases.familyMemberName,
      ),
    );
  }

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

  Future<void> editGenticDiseaseForFamilyMember({
    required String memberCode,
    required String oldMembername,
  }) async {
    safeEmit(
      state.copyWith(
        submitMemberGeneticDiseaseDetailsStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _geneticDiseasesDataEntryRepo.editGenticDiseaseForFamilyMember(
      oldMembername: oldMembername,
      requestBody: FamilyMemberGeneticDiseasesRequestBodyModel(
        name: state.familyMemberName!,
        code: memberCode,
        geneticDiseases: state.geneticDiseases,
      ),
    );

    response.when(
      success: (successMessage) {
        safeEmit(
          state.copyWith(
            message: successMessage,
            submitMemberGeneticDiseaseDetailsStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            submitMemberGeneticDiseaseDetailsStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitHospitalNames() async {
    final response = await sharedRepo.getHospitalNames(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            hospitalNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<bool> deleteFamilyMemberbyNameAndCode({
    required String name,
    required String code,
  }) async {
    safeEmit(state.copyWith(deleteRequestStatus: RequestStatus.initial));
    final result =
        await _geneticDiseasesDataEntryRepo.deleteFamilyMemberbyNameAndCode(
      AppStrings.arabicLang,
      UserTypes.patient.name.firstLetterToUpperCase,
      code,
      name,
    );
    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            message: data,
            deleteRequestStatus: RequestStatus.success,
          ),
        );
        return true;
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            deleteRequestStatus: RequestStatus.failure,
            //  isDeleteRequest: true,
          ),
        );
        return false;
      },
    );
    return false;
  }

  void removeUploadedReport(String url) {
    final updated = List<String>.from(state.reportsUploadedUrls)..remove(url);

    emit(
      state.copyWith(
        reportsUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadReportImagePicked({required String imagePath}) async {
    // 1) Check limit
    if (state.reportsUploadedUrls.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          uploadReportStatus: UploadReportRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        uploadReportStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await sharedRepo.uploadReport(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final updatedReports = List<String>.from(state.reportsUploadedUrls)
          ..add(response.reportUrl);
        emit(
          state.copyWith(
            message: response.message,
            reportsUploadedUrls: updatedReports,
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

  void onNumberOfBrothersChanged(String? value) {
    safeEmit(state.copyWith(noOfBrothers: value));
  }

  void onNumberOfSistersChanged(String? value) {
    safeEmit(state.copyWith(noOfSisters: value));
  }

  void onNumberOfUnclesChanged(String? value) {
    safeEmit(state.copyWith(noOfUncles: value));
  }

  void onNumberOfAuntsChanged(String? value) {
    safeEmit(state.copyWith(noOfAunts: value));
  }

  void onFamilyMemberChanges(String? value) {
    safeEmit(state.copyWith(familyMemberName: value));
  }

  void onNumberOfMaternalUnclesChanged(String? value) {
    safeEmit(state.copyWith(noOfMaternalUncles: value));
  }

  void onNumberOfMaternalAuntsChanged(String? value) {
    safeEmit(state.copyWith(noOfMaternalAunts: value));
  }

  void updateSelectedHospitalName(String? value) {
    safeEmit(state.copyWith(selectedHospital: value));
  }

  void updateSelectedCountry(String? value) {
    safeEmit(state.copyWith(selectedCountryName: value));
  }

  Future<void> getAllGeneticDiseasesClassfications() async {
    final response =
        await _geneticDiseasesDataEntryRepo.getAllGeneticDiseasesClassfications(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (classifications) {
        safeEmit(
          state.copyWith(
            diseasesClassfications: classifications,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> editNoOfFamilyMembers() async {
    safeEmit(
      state.copyWith(
        submitFamilyMemebersNumberStatus: RequestStatus.loading,
      ),
    );
    final response = await _geneticDiseasesDataEntryRepo.editNoOfFamilyMembers(
      requestBody: FamilyMembersModel(
        isFirstTimeAnsweredFamilyMembersQuestions: true,
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
        safeEmit(
          state.copyWith(
            message: result,
            submitFamilyMemebersNumberStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            submitFamilyMemebersNumberStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getIsFirstTimeAnsweredFamilyMembersQuestions() async {
    final response = await _geneticDiseasesDataEntryRepo
        .getIsFirstTimeAnsweredFamilyMembersQuestions();
    response.when(
      success: (isFirstTime) {
        safeEmit(
          state.copyWith(
            isFirstTimeAnsweringFamilyMemberQuestions: isFirstTime,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            isFirstTimeAnsweringFamilyMemberQuestions: false,
          ),
        );
      },
    );
  }

  Future<void> addNewUsertoFamilyTree({
    required String memberName,
    required String memberCode,
  }) async {
    safeEmit(
      state.copyWith(
        addNewUserToFamilyTreeStatus: RequestStatus.initial,
      ),
    );
    final response = await _geneticDiseasesDataEntryRepo.addNewUsertoFamilyTree(
      language: AppStrings.arabicLang,
      requestBody: AddNewUserToFamilyTreeRequestBodyModel(
        name: memberName,
        code: memberCode,
      ),
    );
    response.when(
      success: (result) {
        safeEmit(
          state.copyWith(
            addNewUserToFamilyTreeStatus: RequestStatus.success,
            message: result,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            addNewUserToFamilyTreeStatus: RequestStatus.failure,
            message: error.errors.first,
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
        safeEmit(
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
        safeEmit(
          state.copyWith(message: error.errors.first),
        );
      },
    );
  }

  Future<void> getAllGeneticDiseasesStatus() async {
    final response =
        await _geneticDiseasesDataEntryRepo.getAllGeneticDiseasesStatus(
      language: AppStrings.arabicLang,
      geneticDiseaseName: state.selectedDiseaseName!,
    );

    response.when(
      success: (statues) {
        if (statues.length == 1) {
          safeEmit(
            state.copyWith(
              selectedDiseaseStatus: statues.first,
            ),
          );
          validateRequiredFields();
        }
        safeEmit(
          state.copyWith(
            diseasesStatuses: statues,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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
        safeEmit(
          state.copyWith(
            diseasesNames: statues,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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

  Future<void> submitEditsForPersonalGeneticDiseases() async {
    safeEmit(
      state.copyWith(
        geneticDiseaseDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _geneticDiseasesDataEntryRepo.editPersonalGeneticDiseases(
      id: state.updatedDocumentId,
      requestBody: PersonalGeneticDiseaseRequestBodyModel(
        writtenReport: reportTextController.text.isNotEmpty
            ? reportTextController.text
            : "",
        country: state.selectedCountryName!,
        date: state.diagnosisDate!,
        diseaseCategory: state.geneticDiseaseCategory!, //!TODO: change it later
        geneticDisease: state.selectedDiseaseName!,
        diseaseStatus: state.selectedDiseaseStatus!,
        firstUploadedImages: state.firstImageUploadedUrls,
        secondUploadedImages: state.secondImageUploadedUrls,
        medicalReport: state.reportsUploadedUrls,
        doctor: state.selectedDoctorName!,
        hospital: state.selectedHospital!,
      ),
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (successMessage) {
        safeEmit(
          state.copyWith(
            geneticDiseaseDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            geneticDiseaseDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> initialDataEntryRequests() async {
    await getAllGeneticDiseasesClassfications();
    await emitCountriesData();
    await emitDoctorNames();
    await emitHospitalNames();
  }

  void safeEmit(GeneticDiseasesDataEntryState cubitState) {
    if (!isClosed) emit(cubitState);
  }

  Future<void> submitPersonalGeneticDiseaseDataEntry(S locale) async {
    safeEmit(
      state.copyWith(
        geneticDiseaseDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _geneticDiseasesDataEntryRepo.submitPersonalGeneticDiseaseRequest(
      requestBody: PersonalGeneticDiseaseRequestBodyModel(
        writtenReport: reportTextController.text.isNotEmpty
            ? reportTextController.text
            : locale.no_data_entered,
        date: state.diagnosisDate!,
        diseaseCategory: state.geneticDiseaseCategory!,
        diseaseStatus: state.selectedDiseaseStatus!,
        geneticDisease: state.selectedDiseaseName!,
        doctor: state.selectedDoctorName ?? locale.no_data_entered,
        firstUploadedImages: state.firstImageUploadedUrls,
        secondUploadedImages: state.secondImageUploadedUrls,
        medicalReport: state.reportsUploadedUrls,
        hospital: state.selectedHospital ?? locale.no_data_entered,
        country: state.selectedCountryName ?? locale.no_data_entered,
      ),
    );
    response.when(
      success: (successMessage) {
        safeEmit(
          state.copyWith(
            message: successMessage,
            geneticDiseaseDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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
    safeEmit(state.copyWith(diagnosisDate: date));
    validateRequiredFields();
  }

  Future<void> updateSelectedGeneticDiseaseCategory(String? val) async {
    safeEmit(state.copyWith(geneticDiseaseCategory: val));
    await getGeneticDiseasesBasedOnClassification();
    validateRequiredFields();
  }

  Future<void> updateSelectedDiseaseStatus(String? val) async {
    safeEmit(state.copyWith(selectedDiseaseStatus: val));
    validateRequiredFields();
  }

  Future<void> updateSelectedGeneticDiseaseName(String? val) async {
    safeEmit(state.copyWith(selectedDiseaseName: val));
    validateRequiredFields();
    await getAllGeneticDiseasesStatus();
  }

  void updateSelectedDoctorName(String? value) {
    safeEmit(state.copyWith(selectedDoctorName: value));
  }

  Future<void> emitCountriesData() async {
    final response = await sharedRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            countriesNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  void removeSpecificUploadedSecondImage(String url) {
    final updated = List<String>.from(state.secondImageUploadedUrls)
      ..remove(url);

    safeEmit(
      state.copyWith(
        secondImageUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadFirstImagePicked({required String imagePath}) async {
    // 1) Check limit
    if (state.firstImageUploadedUrls.length >= 8) {
      safeEmit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          firstImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }
    safeEmit(
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
        // add URL to existing list
        final updatedImages = List<String>.from(state.firstImageUploadedUrls)
          ..add(response.imageUrl);
        safeEmit(
          state.copyWith(
            message: response.message,
            firstImageUploadedUrls: updatedImages,
            firstImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            firstImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  void removeSpecificUploadedFirstImage(String url) {
    final updated = List<String>.from(state.firstImageUploadedUrls)
      ..remove(url);

    safeEmit(
      state.copyWith(
        firstImageUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadSecondImagePicked({required String imagePath}) async {
    // 1) Check limit
    if (state.secondImageUploadedUrls.length >= 8) {
      safeEmit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          secondImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }
    safeEmit(
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
        // add URL to existing list
        final updatedImages = List<String>.from(state.secondImageUploadedUrls)
          ..add(response.imageUrl);
        safeEmit(
          state.copyWith(
            message: response.message,
            secondImageUploadedUrls: updatedImages,
            secondImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            message: error.errors.first,
            secondImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitDoctorNames() async {
    final response = await sharedRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            doctorNames: response,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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
      safeEmit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      safeEmit(
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
      safeEmit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await clearAllAddedComplaints();
    reportTextController.dispose();

    noOfBrothers.dispose();
    noOfSisters.dispose();
    noOfUncles.dispose();
    noOfAunts.dispose();
    noOfMaternalUncles.dispose();
    noOfMaternalAunts.dispose();
    return super.close();
  }
}
