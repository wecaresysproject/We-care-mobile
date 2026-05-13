import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_request_body_model.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_data_entry_repo.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

class VaccineDataEntryCubit extends Cubit<VaccineDataEntryState> {
  VaccineDataEntryCubit(this._vaccineDataEntryRepo, this.sharedRepo)
      : super(
          VaccineDataEntryState.initialState(),
        );

  final VaccineDataEntryRepo _vaccineDataEntryRepo;
  final AppSharedRepo sharedRepo;

// جهة تلقي التطعيم
  final vaccinationLocationController = TextEditingController();
  final personalNotesController = TextEditingController();
  // Future<void> loadVaccineDataForEditing(
  //     UserVaccineModel editingVaccineData) async {
  //   safeEmit(
  //     state.copyWith(
  //       vaccineDateSelection: editingVaccineData.vaccineDate,
  //       selectedVaccineName: editingVaccineData.vaccineName,
  //       selectedVaccineCategory: editingVaccineData.vaccineCategory,
  //       selectedCountryName: editingVaccineData.country,
  //       selectedDoseArrangement: editingVaccineData.dose,
  //       vaccinePerfectAge: editingVaccineData.vaccinePerfectAge,
  //       isEditMode: true,
  //       editedVaccineId: editingVaccineData.id,
  //     ),
  //   );
  //   personalNotesController.text = editingVaccineData.notes;
  //   vaccinationLocationController.text = editingVaccineData.regionForVaccine!;
  //   await intialRequestsForVaccineDataEntry();
  // }

  Future<void> submitEditVaccineData(S localozation) async {
    safeEmit(
      state.copyWith(
        vaccineDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _vaccineDataEntryRepo.editVaccineData(
      requestBody: VaccineModuleRequestBody(
        date: state.vaccineDateSelection!,
        targetAge: state.selectedTargetGroup!,
        vaccineName: state.selectedVaccineName!,
        generation: state.selectedBirthGeneration!,
        vaccineCategory: state.vaccineDetails?.vaccineCategory ?? '',
        perfectAge: state.vaccineDetails?.recommendedAge ?? '',
        abbreviationCode: state.vaccineDetails?.abbreviationCode ?? '',
        vaccineActionDescription: state.vaccineDetails?.description ?? '',
        priorityTake: state.vaccineDetails?.priorityTake ?? '',
        targetDisease: state.vaccineDetails?.targetDisease ?? '',
        dose: state.vaccineDetails?.dose ?? '',
        wayToTakeVaccine: state.vaccineDetails?.administrationMethod ?? '',
        vaccinationProvider: vaccinationLocationController.text.isEmpty
            ? localozation.no_data_entered
            : vaccinationLocationController.text,
        country: state.selectedCountryName.isEmptyOrNull
            ? localozation.no_data_entered
            : state.selectedCountryName!,
        additionalInfo: personalNotesController.text.isEmpty
            ? localozation.no_data_entered
            : personalNotesController.text,
      ),
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      vaccineId: state.editedVaccineId!,
    );
    response.when(
      success: (successMessage) {
        safeEmit(
          state.copyWith(
            vaccineDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            vaccineDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
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

  Future<void> emitBirthGenerations() async {
    final response = await _vaccineDataEntryRepo.getBirthGenerations();

    response.when(
      success: (data) {
        safeEmit(state.copyWith(birthGenerations: data));
      },
      failure: (error) {
        safeEmit(state.copyWith(message: error.errors.first));
      },
    );
  }

  Future<void> updateBirthGeneration(String? value) async {
    safeEmit(state.copyWith(
      selectedBirthGeneration: value,
      // Reset dependent fields
      selectedTargetGroup: null,
      targetGroups: [],
      selectedVaccineName: null,
      vaccinesNames: [],
      vaccineDetails: null,
      vaccineDetailsStatus: RequestStatus.initial,
    ));
    validateRequiredFields();
    await emitTargetGroups();
  }

  Future<void> emitTargetGroups() async {
    if (state.selectedBirthGeneration == null) return;
    final response =
        await _vaccineDataEntryRepo.getTargetGroupsByBirthGeneration(
      generation: state.selectedBirthGeneration!,
    );

    response.when(
      success: (data) {
        safeEmit(state.copyWith(targetGroups: data));
      },
      failure: (error) {
        safeEmit(state.copyWith(message: error.errors.first));
      },
    );
  }

  Future<void> updateTargetGroup(String? value) async {
    safeEmit(state.copyWith(
      selectedTargetGroup: value,
      // Reset dependent fields
      selectedVaccineName: null,
      vaccinesNames: [],
      vaccineDetails: null,
      vaccineDetailsStatus: RequestStatus.initial,
    ));
    validateRequiredFields();
    await emitVaccineNames();
  }

  Future<void> emitVaccineNames() async {
    if (state.selectedTargetGroup == null) return;
    final response = await _vaccineDataEntryRepo.getVaccineNamesByTargetGroup(
      generation: state.selectedBirthGeneration!,
      targetAge: state.selectedTargetGroup!,
    );

    response.when(
      success: (data) {
        safeEmit(state.copyWith(vaccinesNames: data));
      },
      failure: (error) {
        safeEmit(state.copyWith(message: error.errors.first));
      },
    );
  }

  /// اختر اسم الطعم
  Future<void> updateVaccineeName(String? selectedVaccineName) async {
    safeEmit(
      state.copyWith(
        selectedVaccineName: selectedVaccineName,
        vaccineDetails: null, // Reset details when name changes
        vaccineDetailsStatus: RequestStatus.initial,
      ),
    );
    validateRequiredFields();
    await emitVaccineDetails();
  }

  Future<void> emitVaccineDetails() async {
    if (state.selectedVaccineName == null) return;
    safeEmit(state.copyWith(vaccineDetailsStatus: RequestStatus.loading));
    final response = await _vaccineDataEntryRepo.getVaccineDetailsByName(
      vaccineName: state.selectedVaccineName!,
      generation: state.selectedBirthGeneration!,
      targetAge: state.selectedTargetGroup!,
    );

    response.when(
      success: (data) {
        safeEmit(state.copyWith(
          vaccineDetails: data,
          vaccineDetailsStatus: RequestStatus.success,
          vaccinePerfectAge:
              data.recommendedAge, // Sync with old field if needed
        ));
      },
      failure: (error) {
        safeEmit(state.copyWith(
          message: error.errors.first,
          vaccineDetailsStatus: RequestStatus.failure,
        ));
      },
    );
  }

  void updateSelectedCountry(String? selectedCountry) {
    safeEmit(
      state.copyWith(
        selectedCountryName: selectedCountry,
      ),
    );
  }

  // ترتيب الجرعه

  void updateVaccineDate(String? vaccineDateSelection) {
    safeEmit(
      state.copyWith(
        vaccineDateSelection: vaccineDateSelection,
      ),
    );
    validateRequiredFields();
  }

  Future<void> intialRequestsForVaccineDataEntry() async {
    await Future.wait([
      emitBirthGenerations(),
      emitCountriesData(),
      emitModuleGuidanceData(),
    ]);
  }

  void validateRequiredFields() {
    if (state.vaccineDateSelection == null ||
        state.selectedBirthGeneration == null ||
        state.selectedTargetGroup == null ||
        state.selectedVaccineName == null) {
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

  Future<void> postVaccineDataEntry(S localozation) async {
    safeEmit(
      state.copyWith(
        vaccineDataEntryStatus: RequestStatus.loading,
      ),
    );
    final requestBody = VaccineModuleRequestBody(
      date: state.vaccineDateSelection!,
      targetAge: state.selectedTargetGroup!,
      vaccineName: state.selectedVaccineName!,
      generation: state.selectedBirthGeneration!,
      vaccineCategory: state.vaccineDetails?.vaccineCategory ?? '',
      perfectAge: state.vaccineDetails?.recommendedAge ?? '',
      abbreviationCode: state.vaccineDetails?.abbreviationCode ?? '',
      vaccineActionDescription: state.vaccineDetails?.description ?? '',
      priorityTake: state.vaccineDetails?.priorityTake ?? '',
      targetDisease: state.vaccineDetails?.targetDisease ?? '',
      dose: state.vaccineDetails?.dose ?? '',
      wayToTakeVaccine: state.vaccineDetails?.administrationMethod ?? '',
      vaccinationProvider: vaccinationLocationController.text.isEmpty
          ? localozation.no_data_entered
          : vaccinationLocationController.text,
      country: state.selectedCountryName.isEmptyOrNull
          ? localozation.no_data_entered
          : state.selectedCountryName!,
      additionalInfo: personalNotesController.text.isEmpty
          ? localozation.no_data_entered
          : personalNotesController.text,
    );
    final response = await _vaccineDataEntryRepo.postVaccineDataEntry(
      requestBody: requestBody,
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (sucessMessage) {
        safeEmit(
          state.copyWith(
            message: sucessMessage,
            vaccineDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        safeEmit(
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

  Future<void> emitModuleGuidanceData() async {
    final response = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.vaccinationsDataEntry.name,
    );
    response.when(
      success: (response) {
        safeEmit(state.copyWith(moduleGuidanceData: response));
      },
      failure: (error) {
        safeEmit(state.copyWith(moduleGuidanceData: null));
      },
    );
  }

  void safeEmit(VaccineDataEntryState newState) {
    if (!isClosed) emit(newState);
  }
}
