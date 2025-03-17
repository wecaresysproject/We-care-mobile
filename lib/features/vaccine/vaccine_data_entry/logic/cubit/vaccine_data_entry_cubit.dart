import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_data_entry_repo.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_state.dart';

class VaccineDataEntryCubit extends Cubit<VaccineDataEntryState> {
  VaccineDataEntryCubit(this._vaccineDataEntryRepo)
      : super(
          VaccineDataEntryState.initialState(),
        );

  final VaccineDataEntryRepo _vaccineDataEntryRepo;

  final personalNotesController = TextEditingController();

  Future<void> emitCountriesData() async {
    final response = await _vaccineDataEntryRepo.getCountriesData(
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

  Future<void> emitVaccineCategories() async {
    final response = await _vaccineDataEntryRepo.getVaccineCategories(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            vaccineCategories: response,
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

// ترتيب الجرعه
  void updateDoseArrangement(String? dose) {
    emit(
      state.copyWith(
        doseArrangement: dose,
      ),
    );
    validateRequiredFields();
  }

  void updateVaccineDate(String? vaccineDateSelection) {
    emit(
      state.copyWith(
        vaccineDateSelection: vaccineDateSelection,
      ),
    );
    validateRequiredFields();
  }

  /// اخترالطعم
  void updateVaccineeName(String? selectedVaccineName) {
    emit(
      state.copyWith(
        selectedvaccineName: selectedVaccineName,
      ),
    );
    validateRequiredFields();
  }

  void updateSelectedVaccineCategory(String? value) {
    emit(
      state.copyWith(
        selectedVaccineCategory: value,
      ),
    );
    validateRequiredFields();
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForVaccineDataEntry() async {
    await emitVaccineCategories();
    await emitCountriesData();
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.vaccineDateSelection == null ||
        state.selectedVaccineCategory == null ||
        state.selectedvaccineName == null ||
        state.doseArrangement == null) {
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

  // Future<void> postVaccineDataEntry(S localozation) async {
  //   emit(
  //     state.copyWith(
  //       vaccineDataEntryStatus: RequestStatus.loading,
  //     ),
  //   );
  //   final response = await _vaccineDataEntryRepo.postVaccineDataEntry(
  //     XrayDataEntryRequestBodyModel(
  //       radiologyDate: state.xRayDateSelection!,
  //       bodyPartName: state.xRayBodyPartSelection!,
  //       radiologyType: state.xRayTypeSelection!,
  //       photo: state.xRayPictureUploadedUrl.isNotEmpty
  //           ? state.xRayPictureUploadedUrl
  //           : localozation.no_data_entered,
  //       report: state.xRayReportUploadedUrl.isNotEmpty
  //           ? state.xRayReportUploadedUrl
  //           : localozation.no_data_entered,
  //       cause: localozation.no_data_entered,
  //       radiologyDoctor: localozation.no_data_entered,
  //       hospital: localozation.no_data_entered,
  //       curedDoctor: localozation.no_data_entered,
  //       country: state.selectedCountryName ?? localozation.no_data_entered,
  //       radiologyNote: personalNotesController.text.isEmpty
  //           ? localozation.no_data_entered
  //           : personalNotesController.text,
  //       userType: UserTypes.patient.name.firstLetterToUpperCase,
  //       language: AppStrings.arabicLang, // TODO: handle it later
  //     ),
  //   );
  //   response.when(
  //     success: (response) {
  //       emit(
  //         state.copyWith(
  //           message: "تم تسجيل البيانات بنجاح",
  //           xRayDataEntryStatus: RequestStatus.success,
  //         ),
  //       );
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           xRayDataEntryStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    return super.close();
  }
}
