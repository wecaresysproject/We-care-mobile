import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_operation_details_by_id.dart';
import 'package:we_care/features/dental_module/data/models/single_teeth_report_post_request.dart';
import 'package:we_care/features/dental_module/data/repos/dental_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'dental_data_entry_state.dart';

class DentalDataEntryCubit extends Cubit<DentalDataEntryState> {
  DentalDataEntryCubit(this._dentalDataEntryRepo, this.sharedRepo)
      : super(
          DentalDataEntryState.initialState(),
        );
  final DentalDataEntryRepo _dentalDataEntryRepo;
  final AppSharedRepo sharedRepo;

  final additionalNotesController = TextEditingController();
  final reportTextController = TextEditingController();

  Future<void> loadPastToothDataForEditing(
    ToothOperationDetails pastToothData, {
    required String teethId,
  }) async {
    emit(
      state.copyWith(
        selectedDentalCenter: pastToothData.dentalCenter,
        pastEditedToothData: pastToothData,
        startIssueDateSelection:
            pastToothData.medicalComplaints.symptomStartDate,
        syptomTypeSelection: pastToothData.medicalComplaints.symptomType,
        selectedSyptomsPeriod: pastToothData.medicalComplaints.symptomDuration,
        natureOfComplaintSelection:
            pastToothData.medicalComplaints.complaintNature,
        complaintDegree: pastToothData.medicalComplaints.painNature,
        medicalProcedureDateSelection: pastToothData.procedure.procedureDate,
        primaryMedicalProcedureSelection:
            pastToothData.procedure.primaryProcedure,
        secondaryMedicalProcedureSelection:
            pastToothData.procedure.subProcedure,
        reportsImageUploadedUrls: pastToothData.medicalReportImage,
        xrayImagesUploadedUrls: pastToothData.xRayImage,
        lymphAnalysisImagesUploadedUrl: pastToothData.lymphAnalysisImage,
        oralPathologySelection: pastToothData.lymphAnalysis,
        selectedSurroundingGumStatus: pastToothData.gumCondition,
        treatingDoctor: pastToothData.treatingDoctor,
        selectedHospitalCenter: pastToothData.hospital,
        selectedCountryName: pastToothData.country,
        isEditMode: true,
        updatedTeethId: teethId,
      ),
    );
    additionalNotesController.text = pastToothData.additionalNotes;
    reportTextController.text = pastToothData.writtenReport ?? "";

    validateRequiredFields();
    await intialRequestsForDataEntry();
  }

  /// Update Field Values
  void updateStartIssueDate(String? date) {
    emit(state.copyWith(startIssueDateSelection: date));
    validateRequiredFields();
  }

  void updateMedicalProcedureDate(String? date) {
    emit(state.copyWith(medicalProcedureDateSelection: date));
  }

  Future<void> updatePrimaryMedicalProcedure(String? val) async {
    emit(state.copyWith(primaryMedicalProcedureSelection: val));
    await emitSecondaryMedicalProcedures();
  }

  void updateSecodaryMedicalProcedure(String? val) {
    emit(state.copyWith(secondaryMedicalProcedureSelection: val));
  }

  void updateOralPathologySelection(String? val) {
    emit(state.copyWith(oralPathologySelection: val));
  }

  void updateSelectedHospitalCenter(String? selectedHospital) {
    emit(state.copyWith(selectedHospitalCenter: selectedHospital));
  }

  void updateSelectedDentalCenter(String? val) {
    emit(state.copyWith(selectedDentalCenter: val));
  }

  void updateSelectedTreatingDoctor(String? val) {
    emit(state.copyWith(treatingDoctor: val));
  }

  void updateSelectedCountry(String? selectedCountry) {
    emit(state.copyWith(selectedCountryName: selectedCountry));
  }

  void updateTypeOfSyptom(String? value) {
    emit(state.copyWith(syptomTypeSelection: value));
    validateRequiredFields();
  }

  void updateNatureOfComplaint(String? val) {
    emit(state.copyWith(natureOfComplaintSelection: val));
    validateRequiredFields();
  }

  void updateSurroundingGumsStatus(String? status) {
    emit(state.copyWith(selectedSurroundingGumStatus: status));
  }

  Future<void> updateComplaintDegree(String? val) async {
    emit(state.copyWith(complaintDegree: val));
    validateRequiredFields();
  }

//مدة الاعراض
  Future<void> updateSyptomsPeriod(String? value) async {
    emit(state.copyWith(selectedSyptomsPeriod: value));
    validateRequiredFields();
  }

  Future<void> intialRequestsForDataEntry() async {
    await Future.wait(
      [
        emitPrimaryMedicalProcedures(),
        emitComplainTypes(),
        emitDoctorNames(),
        emitAllGumsconditions(),
        emitAllOralMedicalTests(),
        emitCountriesData(),
        emitDentalMedicalCenters(),
        emitHospitalNames(),
      ],
    );
  }

  void removeUploadedTeethReport(String url) {
    final updated = List<String>.from(state.reportsImageUploadedUrls)
      ..remove(url);

    emit(
      state.copyWith(
        reportsImageUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> emitDentalMedicalCenters() async {
    final response = await sharedRepo.getDentalMedicalCenters(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            dentalCenters: response,
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

  Future<void> uploadTeethReport({required String imagePath}) async {
    // 1) Check limit
    if (state.reportsImageUploadedUrls.length >= 8) {
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
    final response = await _dentalDataEntryRepo.uploadTeethReport(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final updatedReports = List<String>.from(state.reportsImageUploadedUrls)
          ..add(response.reportUrl);
        emit(
          state.copyWith(
            message: response.message,
            reportsImageUploadedUrls: updatedReports,
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

  void removeUploadedXrayImage(String url) {
    final updated = List<String>.from(state.xrayImagesUploadedUrls)
      ..remove(url);

    emit(
      state.copyWith(
        xrayImagesUploadedUrls: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadXrayImagePicked({required String imagePath}) async {
    // 1) Check limit
    if (state.xrayImagesUploadedUrls.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          xRayImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        xRayImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _dentalDataEntryRepo.uploadXrayImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final xrayImages = List<String>.from(state.xrayImagesUploadedUrls)
          ..add(response.imageUrl);

        emit(
          state.copyWith(
            message: response.message,
            xrayImagesUploadedUrls: xrayImages,
            xRayImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            xRayImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  void removeUploadedLymphImage(String url) {
    final updated = List<String>.from(state.lymphAnalysisImagesUploadedUrl)
      ..remove(url);

    emit(
      state.copyWith(
        lymphAnalysisImagesUploadedUrl: updated,
        message: "تم حذف الصورة",
      ),
    );
  }

  Future<void> uploadLymphAnalysisImage({required String imagePath}) async {
    // 1) Check limit
    if (state.lymphAnalysisImagesUploadedUrl.length >= 8) {
      emit(
        state.copyWith(
          message: "لقد وصلت للحد الأقصى لرفع الصور (8)",
          xRayImageRequestStatus: UploadImageRequestStatus.failure,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        lymphAnalysisImageStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _dentalDataEntryRepo.uploadLymphAnalysisImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final lymphImages =
            List<String>.from(state.lymphAnalysisImagesUploadedUrl)
              ..add(response.imageUrl);
        emit(
          state.copyWith(
            message: response.message,
            lymphAnalysisImagesUploadedUrl: lymphImages,
            lymphAnalysisImageStatus: UploadImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            lymphAnalysisImageStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitCountriesData() async {
    final response = await sharedRepo.getCountriesData(
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

  Future<void> emitComplainTypes() async {
    final response = await _dentalDataEntryRepo.getAllComplainTypes(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            complainTypes: response,
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

  Future<void> emitDoctorNames() async {
    final response = await sharedRepo.getAllDoctors(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
      specialization: "طب اسنان عام",
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

  Future<void> emitHospitalNames() async {
    final response = await sharedRepo.getHospitalNames(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            hospitals: response,
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

  Future<void> emitPrimaryMedicalProcedures() async {
    final response = await _dentalDataEntryRepo.getAllMainMedicalProcedure(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (mainProcedures) {
        emit(
          state.copyWith(
            mainProcedures: mainProcedures,
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

  Future<void> emitAllGumsconditions() async {
    final response = await _dentalDataEntryRepo.getAllGumsconditions(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (result) {
        emit(
          state.copyWith(
            allGumsConditions: result,
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

  Future<void> postOneTeethReportDetails(S locale, String teethNumber) async {
    emit(
      state.copyWith(
        dentalDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _dentalDataEntryRepo.postOneTeethReportDetails(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: SingleTeethReportRequestBody(
        dentalCenter: state.selectedDentalCenter,
        writtenReport: reportTextController.text.isNotEmpty
            ? reportTextController.text
            : locale.no_data_entered,
        teethNumber: teethNumber, //TODO: to change this to dynamic value
        symptomStartDate: state.startIssueDateSelection!,
        symptomType: state.syptomTypeSelection!,
        symptomDuration: state.selectedSyptomsPeriod!,
        complaintNature: state.natureOfComplaintSelection!,
        complaintDegree: state.complaintDegree!,
        procedureDate:
            state.medicalProcedureDateSelection ?? locale.no_data_entered,
        primaryProcedure:
            state.primaryMedicalProcedureSelection ?? locale.no_data_entered,
        subProcedure:
            state.secondaryMedicalProcedureSelection ?? locale.no_data_entered,
        additionalNotes: additionalNotesController.text.isNotEmpty
            ? additionalNotesController.text
            : locale.no_data_entered,
        medicalReportImage: state.reportsImageUploadedUrls,
        xRayImage: state.xrayImagesUploadedUrls,
        lymphAnalysis:
            state.oralPathologySelection ?? locale.no_data_entered, //!check
        lymphAnalysisImage: state.lymphAnalysisImagesUploadedUrl,
        gumCondition:
            state.selectedSurroundingGumStatus ?? locale.no_data_entered,
        treatingDoctor: state.treatingDoctor ?? locale.no_data_entered,
        hospital: state.selectedHospitalCenter,
        country: state.selectedCountryName ?? locale.no_data_entered,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            dentalDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            dentalDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> submitEditedOneTeethReportDetails(
    S locale,
    String decumentId,
    String teethNumber,
  ) async {
    emit(
      state.copyWith(
        dentalDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _dentalDataEntryRepo.updateOneTeethReportDetails(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      documentId: decumentId,
      requestBody: SingleTeethReportRequestBody(
        dentalCenter: state.selectedDentalCenter!,
        writtenReport: reportTextController.text,
        teethNumber: teethNumber,
        symptomStartDate: state.startIssueDateSelection!,
        symptomType: state.syptomTypeSelection!,
        symptomDuration: state.selectedSyptomsPeriod!,
        complaintNature: state.natureOfComplaintSelection!,
        complaintDegree: state.complaintDegree!,
        procedureDate: state.medicalProcedureDateSelection!,
        primaryProcedure: state.primaryMedicalProcedureSelection!,
        subProcedure: state.secondaryMedicalProcedureSelection!,
        additionalNotes: additionalNotesController.text,
        medicalReportImage: state.reportsImageUploadedUrls,
        xRayImage: state.xrayImagesUploadedUrls,
        lymphAnalysis: state.oralPathologySelection!,
        lymphAnalysisImage: state.lymphAnalysisImagesUploadedUrl,
        gumCondition: state.selectedSurroundingGumStatus!,
        treatingDoctor: state.treatingDoctor!,
        hospital: state.selectedHospitalCenter!,
        country: state.selectedCountryName!,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            dentalDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            dentalDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> emitAllOralMedicalTests() async {
    final response = await _dentalDataEntryRepo.getAllOralMedicalTests(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (result) {
        emit(
          state.copyWith(
            allOralMedicalTests: result,
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

  Future<void> emitSecondaryMedicalProcedures() async {
    final response = await _dentalDataEntryRepo.getAllSecondaryMedicalProcedure(
      mainProcedure: state.primaryMedicalProcedureSelection ??
          "", //TODO: to change null to empty string
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (secondaryProcedures) {
        emit(
          state.copyWith(
            secondaryProcedures: secondaryProcedures,
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
    if (state.startIssueDateSelection == null ||
        state.syptomTypeSelection == null ||
        state.selectedSyptomsPeriod == null ||
        state.natureOfComplaintSelection == null ||
        state.complaintDegree == null) {
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
    additionalNotesController.dispose();
    reportTextController.dispose();
    return super.close();
  }
}
