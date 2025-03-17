import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

@immutable
class VaccineDataEntryState extends Equatable {
  final RequestStatus vaccineDataEntryStatus;

  final List<String> countriesNames;
  final List<String> vaccineCategories;
  final String message; // error or success message
  final bool isFormValidated;
  final String? vaccineDateSelection;
  final String? selectedVaccineCategory;
  final String? selectedvaccineName; //الطعم
  final String? selectedCountryName;
  final bool isEditMode;
  final String? doseArrangement; // ترتيب الجرعة

  const VaccineDataEntryState({
    this.countriesNames = const [],
    this.vaccineCategories = const [],
    this.vaccineDataEntryStatus = RequestStatus.initial,
    this.message = '',
    this.isFormValidated = false,
    this.vaccineDateSelection,
    this.selectedvaccineName,
    this.selectedCountryName,
    this.selectedVaccineCategory,
    this.doseArrangement,
    this.isEditMode = false,
  }) : super();

  const VaccineDataEntryState.initialState()
      : this(
          vaccineDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          vaccineDateSelection: null,
          selectedvaccineName: null,
          message: '',
          selectedCountryName: null,
          isEditMode: false,
          doseArrangement: null,
          selectedVaccineCategory: null,
        );

  VaccineDataEntryState copyWith({
    RequestStatus? vaccineDataEntryStatus,
    bool? isFormValidated,
    String? vaccineDateSelection,
    List<String>? countriesNames,
    List<String>? vaccineCategories,
    String? selectedCountryName,
    String? message,
    String? selectedvaccineName,
    bool? isEditMode,
    String? doseArrangement,
    String? selectedVaccineCategory,
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
      selectedvaccineName: selectedvaccineName ?? this.selectedvaccineName,
      isEditMode: isEditMode ?? this.isEditMode,
      doseArrangement: doseArrangement ?? this.doseArrangement,
      selectedVaccineCategory:
          selectedVaccineCategory ?? this.selectedVaccineCategory,
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
        selectedvaccineName,
        isEditMode,
        doseArrangement,
        vaccineCategories,
        selectedVaccineCategory,
      ];
}
