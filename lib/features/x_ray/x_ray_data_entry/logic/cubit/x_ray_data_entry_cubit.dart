import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/x_ray/data/models/body_parts_response_model.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_data_entry_request_body_model.dart';
import 'package:we_care/features/x_ray/data/repos/x_ray_data_entry_repo.dart';
import 'package:we_care/generated/l10n.dart';

part 'x_ray_data_entry_state.dart';

class XRayDataEntryCubit extends Cubit<XRayDataEntryState> {
  XRayDataEntryCubit(this._xRayDataEntryRepo)
      : super(
          XRayDataEntryState.initialState(),
        );

  final XRayDataEntryRepo _xRayDataEntryRepo;

  final personalNotesController = TextEditingController();

  Future<void> emitBodyPartsData() async {
    final response = await _xRayDataEntryRepo.getBodyPartsData();
    if (isClosed) return;

    response.when(
      success: (response) {
        safeEmit(
          state.copyWith(
            bodyPartsDataModels: response,
            bodyPartNames: response.map((e) => e.bodyPartName).toList(),
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

  Future<void> emitCountriesData() async {
    final response = await _xRayDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );
    if (isClosed) return;

    response.when(
      success: (countries) {
        safeEmit(
          state.copyWith(
            countriesNames: countries,
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

  Future<void> emitDoctorNames() async {
    final response = await _xRayDataEntryRepo.getAllDoctors(
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

  void updateSelectedCountry(String? selectedCountry) {
    emit(
      state.copyWith(
        selectedCountryName: selectedCountry,
      ),
    );
  }

  void updateSelectedRadiologistDoctor(String? val) {
    emit(
      state.copyWith(
        selectedRadiologistDoctorName: val,
      ),
    );
  }

  void updateSelectedTreatedDoctor(String? val) {
    emit(
      state.copyWith(
        selectedTreatedDoctor: val,
      ),
    );
  }

  Future<void> intialRequestsForXRayDataEntry() async {
    if (isClosed) return;
    await emitBodyPartsData();
    await emitCountriesData();
    await emitDoctorNames();
  }

  Future<void> _getRadiologyTypeByBodyPartId(String id) async {
    final response = await _xRayDataEntryRepo.getRadiologyTypeByBodyPartId(id);

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            radiologyTypesBasedOnBodyPartNameSelected:
                response.radiologyTypeOfBodyPart.map((e) => e.type).toList(),
            selectedRadiologyTypesOfBodyPartModel:
                response.radiologyTypeOfBodyPart,
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

  Future<void> submitEditsOnXRayDocument(S localozation) async {
    emit(
      state.copyWith(
        xRayDataEntryStatus: RequestStatus.loading,
      ),
    );
    //!because i pass all edited data to loadAnalysisDataForEditing method at begining of my cubit in case i have an model to edit
    final response = await _xRayDataEntryRepo.updateXRayDocumentDetails(
      requestBody: XrayDataEntryRequestBodyModel(
        userType: UserTypes.patient.name.firstLetterToUpperCase,
        language: AppStrings.arabicLang, //TODO: to change later
        radiologyDate: state.xRayDateSelection!,
        bodyPartName: state.xRayBodyPartSelection!,
        radiologyType: state.xRayTypeSelection!,
        radiologyTypePurposes: state.selectedPupose,
        photo: state.xRayPictureUploadedUrl,
        report: state.xRayReportUploadedUrl,
        cause: localozation.no_data_entered,
        radiologyDoctor: localozation.no_data_entered,
        hospital: localozation.no_data_entered,
        curedDoctor: localozation.no_data_entered,
        country: state.selectedCountryName,
        radiologyNote: personalNotesController.text,
      ),
      documentId: state.xRayEditedModel!.id!,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            xRayDataEntryStatus: RequestStatus.success,
            message: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            xRayDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> loadXrayDetailsDataForEditing(
      RadiologyData editingRadiologyDetailsData) async {
    emit(
      state.copyWith(
        xRayDateSelection: editingRadiologyDetailsData.radiologyDate,
        isEditMode: true,
        xRayBodyPartSelection: editingRadiologyDetailsData.bodyPart,
        xRayTypeSelection: editingRadiologyDetailsData.radioType,
        selectedPupose: editingRadiologyDetailsData.periodicUsage,
        xRayPictureUploadedUrl: editingRadiologyDetailsData.radiologyPhoto,
        xRayReportUploadedUrl: editingRadiologyDetailsData.report,
        xRayEditedModel: editingRadiologyDetailsData,
        isXRayPictureSelected: true,
      ),
    );
    personalNotesController.text = editingRadiologyDetailsData.radiologyNote!;
    validateRequiredFields();
    await intialRequestsForXRayDataEntry();
  }

  void updateXRaySelectedPupose(String? selectedPupose) {
    emit(
      state.copyWith(
        selectedPupose: selectedPupose,
      ),
    );
  }

  Future<void> updateXRayBodyPart(String? slectedBodyPartName) async {
    emit(
      state.copyWith(
        xRayBodyPartSelection: slectedBodyPartName,
      ),
    );

    validateRequiredFields();

    String id = "";
    for (var selectedBodyPart in state.bodyPartsDataModels) {
      if (selectedBodyPart.bodyPartName == slectedBodyPartName) {
        id = selectedBodyPart.id;
        break;
      }
    }

    await _getRadiologyTypeByBodyPartId(id);
  }

  /// Update Field Values
  void updateXRayDate(String? date) {
    emit(
      state.copyWith(
        xRayDateSelection: date,
      ),
    );
    validateRequiredFields();
  }

  void _getRadiologySpecifcTypePurposes(String? slectedXRayType) {
    for (var element in state.selectedRadiologyTypesOfBodyPartModel!) {
      if (element.type == slectedXRayType) {
        emit(
          state.copyWith(
            puposesOfSelectedXRayType: element.purposes,
          ),
        );
        break;
      }
    }
  }

  void updateXRayType(String? slectedXRayType) {
    emit(state.copyWith(xRayTypeSelection: slectedXRayType));

    validateRequiredFields();
    _getRadiologySpecifcTypePurposes(slectedXRayType);
  }

  void updateXRayPicture(bool? isImagePicked) {
    emit(state.copyWith(isXRayPictureSelected: isImagePicked));
    validateRequiredFields();
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.xRayDateSelection == null ||
        state.xRayBodyPartSelection == null ||
        state.xRayTypeSelection == null ||
        state.isXRayPictureSelected == null ||
        state.isXRayPictureSelected == false) {
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

  Future<void> uploadXrayImagePicked({required String imagePath}) async {
    emit(
      state.copyWith(
        xRayImageRequestStatus: UploadImageRequestStatus.initial,
      ),
    );
    final response = await _xRayDataEntryRepo.uploadRadiologyImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            xRayPictureUploadedUrl: response.imageUrl,
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

  Future<void> uploadXrayReportPicked({required String imagePath}) async {
    emit(
      state.copyWith(
        xRayReportRequestStatus: UploadReportRequestStatus.initial,
      ),
    );
    final response = await _xRayDataEntryRepo.uploadRadiologyReportImage(
      contentType: AppStrings.contentTypeMultiPartValue,
      language: AppStrings.arabicLang,
      image: File(imagePath),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: response.message,
            xRayReportRequestStatus: UploadReportRequestStatus.success,
            xRayReportUploadedUrl: response.reportUrl,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            xRayReportRequestStatus: UploadReportRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> postRadiologyDataEntry(S localozation) async {
    emit(
      state.copyWith(
        xRayDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _xRayDataEntryRepo.postRadiologyDataEntry(
      XrayDataEntryRequestBodyModel(
        radiologyDate: state.xRayDateSelection!,
        bodyPartName: state.xRayBodyPartSelection!,
        radiologyType: state.xRayTypeSelection!,
        radiologyTypePurposes: state.selectedPupose,
        photo: state.xRayPictureUploadedUrl.isNotEmpty
            ? state.xRayPictureUploadedUrl
            : localozation.no_data_entered,
        report: state.xRayReportUploadedUrl.isNotEmpty
            ? state.xRayReportUploadedUrl
            : localozation.no_data_entered,
        cause: localozation.no_data_entered,
        radiologyDoctor:
            state.selectedRadiologistDoctorName ?? localozation.no_data_entered,
        hospital: localozation.no_data_entered,
        curedDoctor:
            state.selectedTreatedDoctor ?? localozation.no_data_entered,
        country: state.selectedCountryName ?? localozation.no_data_entered,
        radiologyNote: personalNotesController.text.isEmpty
            ? localozation.no_data_entered
            : personalNotesController.text,
        userType: UserTypes.patient.name.firstLetterToUpperCase,
        language: AppStrings.arabicLang, // TODO: handle it later
      ),
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            message: "تم تسجيل البيانات بنجاح",
            xRayDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            xRayDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    DioServices.cancelRequests(
      "Iam closing all requests of xRayDataEntryCubit",
    );
    log('xxx: xray');
    return super.close();
  }

  /// this method is used to emit state only if cubit is not closed
  void safeEmit(XRayDataEntryState newState) {
    if (!isClosed) emit(newState);
  }
}
