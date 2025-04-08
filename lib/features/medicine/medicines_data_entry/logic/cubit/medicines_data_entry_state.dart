import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';

@immutable
class MedicinesDataEntryState extends Equatable {
  final RequestStatus medicinesDataEntryStatus;
  final String? medicineStartDate;
  final String? selectedMedicineName;
  final String? selectedMedicalForm;
  final String? selectedDose;
  final String? selectedNoOfDose;
  final String? doseDuration;
  final String? timePeriods;
  final String? selectedChronicDisease;
  final String? symptomsDiseaseRegion;
  final String? medicalSymptomsIssue;
  final String? selectedDoctorName;
  final bool isFormValidated;
  final List<MedicalComplaint> medicalComplaints;
  final List<String> medicinesNames;
  final List<String> medicineForms;
  final List<String> medicalDoses;
  final String medicineId;
  final List<MedicineBasicInfoModel>? medicinesBasicInfo;

  final bool isEditMode;
  final String message; // error or success message

  const MedicinesDataEntryState({
    this.medicinesDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.medicineStartDate,
    this.selectedMedicineName,
    this.selectedMedicalForm,
    this.selectedDose,
    this.selectedNoOfDose,
    this.doseDuration,
    this.timePeriods,
    this.selectedChronicDisease,
    this.medicalSymptomsIssue,
    this.symptomsDiseaseRegion,
    this.selectedDoctorName,
    this.medicalComplaints = const [],
    this.medicinesNames = const [],
    this.medicineForms = const [],
    this.medicalDoses = const [],
    this.medicinesBasicInfo = const [],
    this.medicineId = '',
  }) : super();

  const MedicinesDataEntryState.initialState()
      : this(
          medicinesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          medicineStartDate: null,
          selectedMedicineName: null,
          selectedMedicalForm: null,
          selectedDose: null,
          selectedNoOfDose: null,
          doseDuration: null,
          timePeriods: null,
          selectedChronicDisease: null,
          medicalSymptomsIssue: null,
          symptomsDiseaseRegion: null,
          selectedDoctorName: null,
          medicalComplaints: const [],
          medicinesNames: const [],
          medicineForms: const [],
          medicalDoses: const [],
          medicinesBasicInfo: const [],
          medicineId: '',
        );

  MedicinesDataEntryState copyWith({
    RequestStatus? emergencyComplaintsDataEntryStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    String? medicineStartDate,
    String? selectedMedicineName,
    String? selectedMedicalForm,
    String? selectedDose,
    String? selectedNoOfDose,
    String? doseDuration,
    String? timePeriods,
    String? selectedChronicDisease,
    String? medicalSymptomsIssue,
    String? symptomsDiseaseRegion,
    String? selectedDoctorName,
    List<MedicalComplaint>? medicalComplaints,
    List<String>? medicinesNames,
    List<String>? medicineForms,
    List<String>? medicalDoses,
    String? medicineId,
    List<MedicineBasicInfoModel>? medicinesBasicInfo,
  }) {
    return MedicinesDataEntryState(
      medicinesDataEntryStatus:
          emergencyComplaintsDataEntryStatus ?? medicinesDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      medicineStartDate: medicineStartDate ?? this.medicineStartDate,
      selectedMedicineName: selectedMedicineName ?? this.selectedMedicineName,
      selectedMedicalForm: selectedMedicalForm ?? this.selectedMedicalForm,
      selectedDose: selectedDose ?? this.selectedDose,
      selectedNoOfDose: selectedNoOfDose ?? this.selectedNoOfDose,
      doseDuration: doseDuration ?? this.doseDuration,
      timePeriods: timePeriods ?? this.timePeriods,
      selectedChronicDisease:
          selectedChronicDisease ?? this.selectedChronicDisease,
      medicalSymptomsIssue: medicalSymptomsIssue ?? this.medicalSymptomsIssue,
      symptomsDiseaseRegion:
          symptomsDiseaseRegion ?? this.symptomsDiseaseRegion,
      selectedDoctorName: selectedDoctorName ?? this.selectedDoctorName,
      medicalComplaints: medicalComplaints ?? this.medicalComplaints,
      medicinesNames: medicinesNames ?? this.medicinesNames,
      medicineForms: medicineForms ?? this.medicineForms,
      medicalDoses: medicalDoses ?? this.medicalDoses,
      medicineId: medicineId ?? this.medicineId,
      medicinesBasicInfo: medicinesBasicInfo ?? this.medicinesBasicInfo,
    );
  }

  @override
  List<Object?> get props => [
        medicinesDataEntryStatus,
        isFormValidated,
        message,
        isEditMode,
        medicineStartDate,
        selectedMedicineName,
        selectedMedicalForm,
        selectedDose,
        selectedNoOfDose,
        doseDuration,
        timePeriods,
        selectedChronicDisease,
        medicalSymptomsIssue,
        symptomsDiseaseRegion,
        selectedDoctorName,
        medicalComplaints,
        medicinesNames,
        medicineForms,
        medicalDoses,
        medicineId,
        medicinesBasicInfo,
      ];
}
