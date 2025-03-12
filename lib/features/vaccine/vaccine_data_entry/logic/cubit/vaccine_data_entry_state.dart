import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';

@immutable
class VaccineDataEntryState extends Equatable {
  final RequestStatus vaccineDataEntryStatus;

  final List<String> countriesNames;
  final String message; // error or success message
  final bool isFormValidated;
  final String? xRayDateSelection;
  final String? xRayBodyPartSelection;
  final String? xRayTypeSelection;
  final String? selectedCountryName;
  final bool? isXRayPictureSelected;
  final String xRayPictureUploadedUrl;

  final String xRayReportUploadedUrl;
  final UploadImageRequestStatus xRayImageRequestStatus;
  final UploadReportRequestStatus xRayReportRequestStatus;

  const VaccineDataEntryState({
    this.countriesNames = const [],
    this.vaccineDataEntryStatus = RequestStatus.initial,
    this.message = '',
    this.isFormValidated = false,
    this.xRayDateSelection,
    this.xRayBodyPartSelection,
    this.selectedCountryName,
    this.xRayTypeSelection,
    this.isXRayPictureSelected,
    this.xRayPictureUploadedUrl = '',
    this.xRayReportUploadedUrl = '',
    this.xRayImageRequestStatus = UploadImageRequestStatus.initial,
    this.xRayReportRequestStatus = UploadReportRequestStatus.initial,
  }) : super();

  const VaccineDataEntryState.initialState()
      : this(
          vaccineDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          xRayDateSelection: null,
          xRayBodyPartSelection: null,
          xRayTypeSelection: null,
          isXRayPictureSelected: null,
          message: '',
          selectedCountryName: null,
          xRayImageRequestStatus: UploadImageRequestStatus.initial,
          xRayReportRequestStatus: UploadReportRequestStatus.initial,
        );

  VaccineDataEntryState copyWith({
    RequestStatus? vaccineDataEntryStatus,
    bool? isFormValidated,
    String? xRayDateSelection,
    String? xRayBodyPartSelection,
    String? xRayTypeSelection,
    bool? isXRayPictureSelected,
    List<String>? bodyPartNames,
    List<String>? radiologyTypesBasedOnBodyPartNameSelected,
    List<String>? countriesNames,
    String? selectedCountryName,
    String? selectedPupose,
    String? message,
    String? xRayPictureUploadedUrl,
    String? xRayReportUploadedUrl,
    UploadImageRequestStatus? xRayImageRequestStatus,
    UploadReportRequestStatus? xRayReportRequestStatus,
  }) {
    return VaccineDataEntryState(
      vaccineDataEntryStatus:
          vaccineDataEntryStatus ?? this.vaccineDataEntryStatus,
      message: message ?? this.message,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      xRayDateSelection: xRayDateSelection ?? this.xRayDateSelection,
      xRayBodyPartSelection:
          xRayBodyPartSelection ?? this.xRayBodyPartSelection,
      xRayTypeSelection: xRayTypeSelection ?? this.xRayTypeSelection,
      isXRayPictureSelected:
          isXRayPictureSelected ?? this.isXRayPictureSelected,
      countriesNames: countriesNames ?? this.countriesNames,
      selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      xRayPictureUploadedUrl:
          xRayPictureUploadedUrl ?? this.xRayPictureUploadedUrl,
      xRayReportUploadedUrl:
          xRayReportUploadedUrl ?? this.xRayReportUploadedUrl,
      xRayImageRequestStatus:
          xRayImageRequestStatus ?? this.xRayImageRequestStatus,
      xRayReportRequestStatus:
          xRayReportRequestStatus ?? this.xRayReportRequestStatus,
    );
  }

  @override
  List<Object?> get props => [
        vaccineDataEntryStatus,
        message,
        isFormValidated,
        xRayDateSelection,
        xRayBodyPartSelection,
        xRayTypeSelection,
        isXRayPictureSelected,
        countriesNames,
        selectedCountryName,
        xRayPictureUploadedUrl,
        xRayReportUploadedUrl,
        xRayImageRequestStatus,
        xRayReportRequestStatus,
      ];
}
