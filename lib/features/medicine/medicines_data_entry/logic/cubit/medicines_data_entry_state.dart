import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

@immutable
class MedicinesDataEntryState extends Equatable {
  final RequestStatus medicinesDataEntryStatus;
  final String? medicineStartDate;
  final String? selectedMedicineName;
  final String? wayToUseMedicine;
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

  final bool isEditMode;
  final String message; // error or success message

  const MedicinesDataEntryState({
    this.medicinesDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.medicineStartDate,
    this.selectedMedicineName,
    this.wayToUseMedicine,
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
  }) : super();

  const MedicinesDataEntryState.initialState()
      : this(
          medicinesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          medicineStartDate: null,
          selectedMedicineName: null,
          wayToUseMedicine: null,
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
        );

  MedicinesDataEntryState copyWith({
    RequestStatus? emergencyComplaintsDataEntryStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    String? medicineStartDate,
    String? selectedMedicineName,
    String? wayToUseMedicine,
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
  }) {
    return MedicinesDataEntryState(
      medicinesDataEntryStatus:
          emergencyComplaintsDataEntryStatus ?? medicinesDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      medicineStartDate: medicineStartDate ?? this.medicineStartDate,
      selectedMedicineName: selectedMedicineName ?? this.selectedMedicineName,
      wayToUseMedicine: wayToUseMedicine ?? this.wayToUseMedicine,
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
        wayToUseMedicine,
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
      ];
}
