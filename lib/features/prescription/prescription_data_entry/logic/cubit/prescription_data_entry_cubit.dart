import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';
import 'package:we_care/features/prescription/data/repos/prescription_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'prescription_data_entry_state.dart';

class PrescriptionDataEntryCubit extends Cubit<PrescriptionDataEntryState> {
  PrescriptionDataEntryCubit(this._prescriptionDataEntryRepo, this.sharedRepo)
      : super(
          PrescriptionDataEntryState.initialState(),
        );
  final PrescriptionDataEntryRepo _prescriptionDataEntryRepo;
  final AppSharedRepo sharedRepo;

  final personalNotesController = TextEditingController();
  final symptomsAccompanyingComplaintController =
      TextEditingController(); // الاعراض المصاحبة للشكوى
  final diagnosisController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  /// Update Field Values
  void updatePrescriptionDate(String? date) {
    emit(state.copyWith(preceriptionDateSelection: date));
    validateRequiredFields();
  }

  void updateDoctorName(String? doctorName) {
    emit(state.copyWith(doctorNameSelection: doctorName));
    validateRequiredFields();
  }

  void updateDoctorSpeciality(String? speciality) {
    emit(state.copyWith(doctorSpecialitySelection: speciality));
    validateRequiredFields();
  }

  Future<void> updateSelectedCountry(String? selectedCountry) async {
    emit(
      state.copyWith(
        selectedCountryName: selectedCountry,
      ),
    );
    await emitCitiesData();
  }

  void updateSelectedCityName(String? selectedCity) {
    emit(
      state.copyWith(
        selectedCityName: selectedCity,
      ),
    );
  }

  void updateSelectedHospitalName(String? selectedHospital) {
    emit(
      state.copyWith(
        selectedHospitalName: selectedHospital,
      ),
    );
    validateRequiredFields();
  }

  Future<void> submitEditsOnPrescription(S localize) async {
    emit(
      state.copyWith(
        preceriptionDataEntryStatus: RequestStatus.loading,
      ),
    );
    //!because i pass all edited data to loadAnalysisDataForEditing method at begining of my cubit in case i have an model to edit
    final response =
        await _prescriptionDataEntryRepo.updatePrescriptionDocumentDetails(
      requestBody: PrescriptionRequestBodyModel(
        userType: UserTypes.patient.name.firstLetterToUpperCase,
        language: AppStrings.arabicLang, //TODO: to change later
        prescriptionDate: state.preceriptionDateSelection!,
        doctorName: state.doctorNameSelection ?? localize.no_data_entered,
        doctorSpecialty: state.doctorSpecialitySelection!,
        cause: symptomsAccompanyingComplaintController.text,
        disease: diagnosisController.text,
        preDescriptionPhoto: state.prescriptionPictureUploadedUrl,
        country: state.selectedCountryName!,
        governate: state.selectedCityName!,
        hospital: state.selectedHospitalName ?? localize.no_data_entered,
        preDescriptionNotes: personalNotesController.text,
      ),
      documentId: state.prescribtionEditedModel!.id,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            preceriptionDataEntryStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            preceriptionDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> loadPrescriptionDataForEditing(
      PrescriptionModel editingPrescriptionDetailsData) async {
    emit(
      state.copyWith(
        preceriptionDateSelection:
            editingPrescriptionDetailsData.preDescriptionDate,
        isEditMode: true,
        doctorNameSelection: editingPrescriptionDetailsData.doctorName,
        doctorSpecialitySelection:
            editingPrescriptionDetailsData.doctorSpecialty,
        selectedCountryName: editingPrescriptionDetailsData.country,
        selectedCityName: editingPrescriptionDetailsData.governate, //TODO:
        selectedHospitalName: editingPrescriptionDetailsData.hospital,
        prescriptionPictureUploadedUrl:
            editingPrescriptionDetailsData.preDescriptionPhoto,
        prescriptionImageRequestStatus: UploadImageRequestStatus.success,
        isPrescriptionPictureSelected: true,
        prescribtionEditedModel: editingPrescriptionDetailsData,
      ),
    );
    personalNotesController.text =
        editingPrescriptionDetailsData.preDescriptionNotes;
    symptomsAccompanyingComplaintController.text =
        editingPrescriptionDetailsData.cause;
    diagnosisController.text = editingPrescriptionDetailsData.disease;
    validateRequiredFields();
    await intialRequestsForPrescriptionDataEntry();
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForPrescriptionDataEntry() async {
    Future.wait([
      emitModuleGuidanceData(),
      emitDoctorNames(),
      emitCountriesData(),
      emitCitiesData(),
      emitDoctorsSpecializations(),
      emitHospitalNames(),
    ]);
  }

  Future<void> emitDoctorNames() async {
    final response = await sharedRepo.getAllDoctors(
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

  Future<void> emitCitiesData() async {
    final response = await sharedRepo.getCitiesBasedOnCountryName(
      language: AppStrings.arabicLang,
      countryName: state.selectedCountryName ?? "Egypt",
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

  Future<void> emitHospitalNames() async {
    final response = await sharedRepo.getHospitalNames(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (hospitals) {
        emit(
          state.copyWith(
            hospitalNames: hospitals,
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

  Future<void> emitDoctorsSpecializations() async {
    final response = await sharedRepo.getDoctorsSpecializations(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            doctorSpecialities: response,
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

  void removeUploadedImage(String url) {
    final updated = List<String>.from(state.prescriptionPictureUploadedUrl)
      ..remove(url);

    emit(
      state.copyWith(
        prescriptionPictureUploadedUrl: updated,
        message: "تم حذف الصورة",
      ),
    );
    validateRequiredFields();
  }

  Future<void> uploadPrescriptionImagePicked(
      {required String imagePath}) async {
    // 1) Check limit
    if (state.prescriptionPictureUploadedUrl.length >= 4) {
      emit(
        state.copyWith(
          prescriptionImageRequestStatus: UploadImageRequestStatus.failure,
          message: "لقد وصلت للحد الأقصى لرفع الصور (4) للروشتة الواحدة",
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        prescriptionImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _prescriptionDataEntryRepo.uploadPrescriptionImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        // add URL to existing list
        final updatedPrescribtions =
            List<String>.from(state.prescriptionPictureUploadedUrl)
              ..add(response.imageUrl);
        emit(
          state.copyWith(
            message: response.message,
            prescriptionPictureUploadedUrl: updatedPrescribtions,
            prescriptionImageRequestStatus: UploadImageRequestStatus.success,
          ),
        );
        validateRequiredFields();
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            prescriptionImageRequestStatus: UploadImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> postPrescriptionDataEntry(S localozation) async {
    emit(
      state.copyWith(
        preceriptionDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _prescriptionDataEntryRepo.postPrescriptionDataEntry(
      PrescriptionRequestBodyModel(
        prescriptionDate: state.preceriptionDateSelection!,

        userType: UserTypes.patient.name.firstLetterToUpperCase,
        language: AppStrings.arabicLang,
        doctorName: state.doctorNameSelection ?? localozation.no_data_entered,
        country: state.selectedCountryName ?? localozation.no_data_entered,

        cause: symptomsAccompanyingComplaintController.text.isNotEmpty
            ? symptomsAccompanyingComplaintController.text
            : localozation.no_data_entered,
        disease: diagnosisController.text.isNotEmpty
            ? diagnosisController.text
            : localozation.no_data_entered,
        preDescriptionPhoto: state.prescriptionPictureUploadedUrl,
        governate: state.selectedCityName ?? localozation.no_data_entered,
        hospital: state.selectedHospitalName ?? localozation.no_data_entered,
        preDescriptionNotes: personalNotesController.text.isNotEmpty
            ? personalNotesController.text
            : localozation.no_data_entered,
        doctorSpecialty:
            state.doctorSpecialitySelection ?? localozation.no_data_entered,
      ),
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            preceriptionDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            preceriptionDataEntryStatus: RequestStatus.failure,
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

  void updatePrescriptionPicture(bool? isImagePicked) {
    emit(state.copyWith(isPrescriptionPictureSelected: isImagePicked));
    validateRequiredFields();
  }

  void validateRequiredFields() {
    // اسم الطبيب واسم المستشفى/العيادة: يكفي إدخال واحد منهم على الأقل
    final hasDoctorOrHospital =
        state.doctorNameSelection != null || state.selectedHospitalName != null;

    if (state.preceriptionDateSelection == null ||
        !hasDoctorOrHospital ||
        state.doctorSpecialitySelection == null ||
        state.prescriptionPictureUploadedUrl.isEmpty) {
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

  Future<void> emitModuleGuidanceData() async {
    final response = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.prescriptionsDataEntry.name,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            moduleGuidanceData: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    symptomsAccompanyingComplaintController.dispose();
    diagnosisController.dispose();
    formKey.currentState?.reset();
    return super.close();
  }
}
