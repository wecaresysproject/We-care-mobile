import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_operation_details_by_id.dart';
import 'package:we_care/features/dental_module/data/models/single_teeth_report_post_request.dart';
import 'package:we_care/features/dental_module/data/repos/dental_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'dental_data_entry_state.dart';

class DentalDataEntryCubit extends Cubit<DentalDataEntryState> {
  DentalDataEntryCubit(this._dentalDataEntryRepo)
      : super(
          DentalDataEntryState.initialState(),
        );
  final DentalDataEntryRepo _dentalDataEntryRepo;
  final additionalNotesController = TextEditingController();

  Future<void> loadPastToothDataForEditing(
    ToothOperationDetails pastToothData, {
    required String teethId,
  }) async {
    emit(
      state.copyWith(
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
        reportImageUploadedUrl: pastToothData.medicalReportImage,
        xrayImageUploadedUrl: pastToothData.xRayImage,
        lymphAnalysisImageUploadedUrl: pastToothData.lymphAnalysisImage,
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
        emitComaplainsDurations(),
        emitComplainNatures(),
        emitDoctorNames(),
        emitAllGumsconditions(),
        emitAllOralMedicalTests(),
        emitCountriesData(),
      ],
    );
  }

  Future<void> uploadTeethReport({required String imagePath}) async {
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

  Future<void> uploadXrayImagePicked({required String imagePath}) async {
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
        emit(
          state.copyWith(
            message: response.message,
            xrayImageUploadedUrl: response.imageUrl,
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

  Future<void> uploadLymphAnalysisImage({required String imagePath}) async {
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
        emit(
          state.copyWith(
            message: response.message,
            lymphAnalysisImageUploadedUrl: response.imageUrl,
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
    final response = await _dentalDataEntryRepo.getCountriesData(
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

  Future<void> emitComaplainsDurations() async {
    final response = await _dentalDataEntryRepo.getAllComaplainsDurations(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            complainDurations: response,
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

  Future<void> emitComplainNatures() async {
    final response = await _dentalDataEntryRepo.getAllComplainNatures(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            complainNatures: response,
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
    final response = await _dentalDataEntryRepo.getAllDoctors(
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
        medicalReportImage:
            state.reportImageUploadedUrl ?? locale.no_data_entered,
        xRayImage: state.xrayImageUploadedUrl ?? locale.no_data_entered,
        lymphAnalysis:
            state.oralPathologySelection ?? locale.no_data_entered, //!check
        lymphAnalysisImage:
            state.lymphAnalysisImageUploadedUrl ?? locale.no_data_entered,
        gumCondition:
            state.selectedSurroundingGumStatus ?? locale.no_data_entered,
        treatingDoctor: state.treatingDoctor ?? locale.no_data_entered,
        hospital: state.selectedHospitalCenter ?? locale.no_data_entered,
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
        medicalReportImage: state.reportImageUploadedUrl!,
        xRayImage: state.xrayImageUploadedUrl!,
        lymphAnalysis: state.oralPathologySelection!,
        lymphAnalysisImage: state.lymphAnalysisImageUploadedUrl!,
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
    return super.close();
  }
}
