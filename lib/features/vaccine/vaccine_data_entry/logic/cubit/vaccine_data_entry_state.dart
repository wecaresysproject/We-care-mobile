import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/vaccine/data/models/vaccine_model.dart';

@immutable
class VaccineDataEntryState extends Equatable {
  final RequestStatus vaccineDataEntryStatus;

  final List<String> countriesNames;
  final List<String> vaccineCategories;
  final List<String> vaccinesNames;
  final List<VaccineModel> vaccinesDataList;
  final String message; // error or success message
  final bool isFormValidated;
  final String? vaccineDateSelection;
  final String? selectedVaccineCategory;
  final String? selectedVaccineName; //الطعم
  final String? selectedCountryName;
  final bool isEditMode;
  final String? selectedDoseArrangement; // ترتيب الجرعة
  final List<String> doseArrangementData;
  final String? vaccinePerfectAge;
  final String? editedVaccineId;

  const VaccineDataEntryState({
    this.countriesNames = const [],
    this.vaccineCategories = const [],
    this.vaccinesNames = const [],
    this.vaccinesDataList = const [],
    this.doseArrangementData = const [],
    this.vaccineDataEntryStatus = RequestStatus.initial,
    this.message = '',
    this.isFormValidated = false,
    this.vaccineDateSelection,
    this.selectedVaccineName,
    this.selectedCountryName,
    this.selectedVaccineCategory,
    this.selectedDoseArrangement,
    this.vaccinePerfectAge,
    this.editedVaccineId,
    this.isEditMode = false,
  }) : super();

  const VaccineDataEntryState.initialState()
      : this(
          vaccineDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          vaccineDateSelection: null,
          selectedVaccineName: null,
          message: '',
          selectedCountryName: null,
          isEditMode: false,
          selectedDoseArrangement: null,
          selectedVaccineCategory: null,
          vaccinePerfectAge: null,
          editedVaccineId: null,
        );

  VaccineDataEntryState copyWith({
    RequestStatus? vaccineDataEntryStatus,
    bool? isFormValidated,
    String? vaccineDateSelection,
    List<String>? countriesNames,
    List<String>? vaccineCategories,
    String? selectedCountryName,
    String? message,
    String? selectedVaccineName,
    bool? isEditMode,
    String? selectedDoseArrangement,
    String? selectedVaccineCategory,
    List<String>? vaccinesNames,
    List<VaccineModel>? vaccinesDataList,
    List<String>? doseArrangementData,
    String? vaccinePerfectAge,
    String? editedVaccineId,
  }) {
    return VaccineDataEntryState(
      vaccineDataEntryStatus:
          vaccineDataEntryStatus ?? this.vaccineDataEntryStatus,
      message: message ?? this.message,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      vaccineDateSelection: vaccineDateSelection ?? this.vaccineDateSelection,
      countriesNames: countriesNames ?? this.countriesNames,
      vaccineCategories: vaccineCategories ?? this.vaccineCategories,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      selectedVaccineName: selectedVaccineName ?? this.selectedVaccineName,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedDoseArrangement:
          selectedDoseArrangement ?? this.selectedDoseArrangement,
      selectedVaccineCategory:
          selectedVaccineCategory ?? this.selectedVaccineCategory,
      vaccinesNames: vaccinesNames ?? this.vaccinesNames,
      vaccinesDataList: vaccinesDataList ?? this.vaccinesDataList,
      doseArrangementData: doseArrangementData ?? this.doseArrangementData,
      vaccinePerfectAge: vaccinePerfectAge ?? this.vaccinePerfectAge,
      editedVaccineId: editedVaccineId ?? this.editedVaccineId,
    );
  }

  @override
  List<Object?> get props => [
        vaccineDataEntryStatus,
        message,
        isFormValidated,
        vaccineDateSelection,
        countriesNames,
        selectedCountryName,
        selectedVaccineName,
        isEditMode,
        selectedDoseArrangement,
        vaccineCategories,
        selectedVaccineCategory,
        vaccinesNames,
        vaccinesDataList,
        doseArrangementData,
        vaccinePerfectAge,
        editedVaccineId,
      ];
}
