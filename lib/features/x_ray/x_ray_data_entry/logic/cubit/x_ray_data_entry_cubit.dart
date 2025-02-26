import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/x_ray/data/models/body_parts_response_model.dart';
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

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            bodyPartsDataModels: response,
            bodyPartNames: response.map((e) => e.bodyPartName).toList(),
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

  Future<void> emitCountriesData() async {
    final response = await _xRayDataEntryRepo.getCountriesData(
      language: AppStrings.arabicLang,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            countriesNames: response.map((e) => e.name).toList(),
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

  Future<void> intialRequestsForXRayDataEntry() async {
    await emitBodyPartsData();
    await emitCountriesData();
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
            xRayImageRequestStatus: XRayImageRequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            xRayImageRequestStatus: XRayImageRequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> uploadXrayReportPicked({required String imagePath}) async {
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
            xRayReportRequestStatus: XRayReportRequestStatus.success,
            xRayReportUploadedUrl: response.reportUrl,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            xRayReportRequestStatus: XRayReportRequestStatus.failure,
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
        radiologyDoctor: localozation.no_data_entered,
        hospital: localozation.no_data_entered,
        curedDoctor: localozation.no_data_entered,
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
    return super.close();
  }
}
