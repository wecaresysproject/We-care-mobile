import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_request_body_model.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_data_entry_repo.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

class VaccineDataEntryCubit extends Cubit<VaccineDataEntryState> {
  VaccineDataEntryCubit(this._vaccineDataEntryRepo)
      : super(
          VaccineDataEntryState.initialState(),
        );

  final VaccineDataEntryRepo _vaccineDataEntryRepo;
// جهة تلقي التطعيم
  final vaccinationLocationController = TextEditingController();
  final personalNotesController = TextEditingController();
  Future<void> loadVaccineDataForEditing(
      UserVaccineModel editingVaccineData) async {
    emit(
      state.copyWith(
        vaccineDateSelection: editingVaccineData.vaccineDate,
        selectedVaccineName: editingVaccineData.vaccineName,
        selectedVaccineCategory: editingVaccineData.vaccineCategory,
        selectedCountryName: editingVaccineData.country,
        selectedDoseArrangement: editingVaccineData.dose,
        vaccinePerfectAge: editingVaccineData.vaccinePerfectAge,
        isEditMode: true,
        editedVaccineId: editingVaccineData.id,
      ),
    );
    personalNotesController.text = editingVaccineData.notes;
    vaccinationLocationController.text = editingVaccineData.regionForVaccine!;
    await intialRequestsForVaccineDataEntry();
  }

  Future<void> submitEditVaccineData(S localozation) async {
    emit(
      state.copyWith(
        vaccineDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _vaccineDataEntryRepo.editVaccineData(
      requestBody: VaccineModuleRequestBody(
        vaccineName: state.selectedVaccineName!,
        vaccineDate: state.vaccineDateSelection!,
        vaccineCategory: state.selectedVaccineCategory!,
        vaccinePerfectAge: state.vaccinePerfectAge!,
        dose: state.selectedDoseArrangement!,
        regionForVaccine: vaccinationLocationController.text.isEmpty
            ? localozation.no_data_entered
            : vaccinationLocationController.text,
        country: state.selectedCountryName.isEmptyOrNull
            ? localozation.no_data_entered
            : state.selectedCountryName!,
        notes: personalNotesController.text.isEmpty
            ? localozation.no_data_entered
            : personalNotesController.text,
      ),
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      vaccineId: state.editedVaccineId!,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            vaccineDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            vaccineDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

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
        selectedDoseArrangement: dose,
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

  /// اختر اسم الطعم
  void updateVaccineeName(String? selectedVaccineName) {
    emit(
      state.copyWith(
        selectedVaccineName: selectedVaccineName,
      ),
    );
    validateRequiredFields();
    getDoseArrangement();
  }

  Future<void> updateSelectedVaccineCategory(String? value) async {
    emit(
      state.copyWith(
        selectedVaccineCategory: value,
      ),
    );
    validateRequiredFields();
    await emitVaccineResultsByCategoryName();
  }

  //! crash app when user try get into page and go back in afew seconds , gives me error state emitted after cubit closed
  Future<void> intialRequestsForVaccineDataEntry() async {
    await emitVaccineCategories();
    await emitCountriesData();
  }

  Future<void> emitVaccineResultsByCategoryName() async {
    final response =
        await _vaccineDataEntryRepo.getVaccineResultsByCategoryName(
      vaccineCategory:
          state.selectedVaccineCategory!, //TODO: handle null check later
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );

    response.when(
      success: (response) {
        final vaccineNames = response
            .map(
              (e) => e.vaccineName,
            )
            .toList();
        emit(
          state.copyWith(
            vaccinesDataList: response,
            vaccinesNames: vaccineNames,
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

  void getDoseArrangement() {
    for (var element in state.vaccinesDataList) {
      if (element.vaccineName == state.selectedVaccineName) {
        emit(
          state.copyWith(
            doseArrangementData: element.doses,
            vaccinePerfectAge: element.vaccinePerfectAge,
          ),
        );
      }
    }
  }

  /// state.isXRayPictureSelected == false => image rejected
  void validateRequiredFields() {
    if (state.vaccineDateSelection == null ||
        state.selectedVaccineCategory == null ||
        state.selectedVaccineName == null ||
        state.selectedDoseArrangement == null) {
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

  Future<void> postVaccineDataEntry(S localozation) async {
    emit(
      state.copyWith(
        vaccineDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _vaccineDataEntryRepo.postVaccineDataEntry(
      requestBody: VaccineModuleRequestBody(
        vaccineName: state.selectedVaccineName!,
        vaccineDate: state.vaccineDateSelection!,
        vaccineCategory: state.selectedVaccineCategory!,
        vaccinePerfectAge: state.vaccinePerfectAge!,
        dose: state.selectedDoseArrangement!,
        regionForVaccine: vaccinationLocationController.text.isEmpty
            ? localozation.no_data_entered
            : vaccinationLocationController.text,
        country: state.selectedCountryName.isEmptyOrNull
            ? localozation.no_data_entered
            : state.selectedCountryName!,
        notes: personalNotesController.text.isEmpty
            ? localozation.no_data_entered
            : personalNotesController.text,
      ),
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (sucessMessage) {
        emit(
          state.copyWith(
            message: sucessMessage,
            vaccineDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            vaccineDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    personalNotesController.dispose();
    vaccinationLocationController.dispose();
    return super.close();
  }
}
