import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

@immutable
class VaccineDataEntryState extends Equatable {
  final RequestStatus vaccineDataEntryStatus;

  final List<String> countriesNames;
  final String message; // error or success message
  final bool isFormValidated;
  final String? vaccineDateSelection;
  final String? selectedvaccineName; //الطعم
  final String? selectedCountryName;
  final bool isEditMode;
  final String? doseArrangement; // ترتيب الجرعة

  const VaccineDataEntryState({
    this.countriesNames = const [],
    this.vaccineDataEntryStatus = RequestStatus.initial,
    this.message = '',
    this.isFormValidated = false,
    this.vaccineDateSelection,
    this.selectedvaccineName,
    this.selectedCountryName,
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
        );

  VaccineDataEntryState copyWith({
    RequestStatus? vaccineDataEntryStatus,
    bool? isFormValidated,
    String? vaccineDateSelection,
    List<String>? countriesNames,
    String? selectedCountryName,
    String? message,
    String? selectedvaccineName,
    bool? isEditMode,
    String? doseArrangement,
  }) {
    return VaccineDataEntryState(
      vaccineDataEntryStatus:
          vaccineDataEntryStatus ?? this.vaccineDataEntryStatus,
      message: message ?? this.message,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      vaccineDateSelection: vaccineDateSelection ?? this.vaccineDateSelection,
      countriesNames: countriesNames ?? this.countriesNames,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      selectedvaccineName: selectedvaccineName ?? this.selectedvaccineName,
      isEditMode: isEditMode ?? this.isEditMode,
      doseArrangement: doseArrangement ?? this.doseArrangement,
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
      ];
}
