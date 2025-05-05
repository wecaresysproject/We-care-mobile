import 'package:alarm/model/alarm_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';
import 'package:we_care/features/medicine/data/models/matched_medicines_model.dart';

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
  final String? selectedDoctorName;
  final bool isFormValidated;
  final List<MedicalComplaint> medicalComplaints;
  final List<String> medicinesNames;
  final List<String> medicineForms;
  final List<String> medicalDoses;
  final String medicineId;
  final String updatedDocumentId;
  final List<MedicineBasicInfoModel>? medicinesBasicInfo;
  final List<String> dosageFrequencies; // عدد مرات الجرعات
  final List<String> allUsageCategories; // مدة الاستخدام
  final List<String> allDurationsBasedOnCategory; // المدد الزمنيه
  final String? selectedAlarmTime;
  final OptionsLoadingState medicinesNamesOptionsLoadingState;
  final bool isEditMode;
  final String message; // error or success message

  final AlarmSettings? ringingAlarm;
  final List<MatchedMedicineModel> matchedMedicines;

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
    this.selectedDoctorName,
    this.medicalComplaints = const [],
    this.medicinesNames = const [],
    this.medicineForms = const [],
    this.medicalDoses = const [],
    this.medicinesBasicInfo = const [],
    this.dosageFrequencies = const [],
    this.allUsageCategories = const [],
    this.allDurationsBasedOnCategory = const [],
    this.medicineId = '',
    this.updatedDocumentId = '',
    this.selectedAlarmTime,
    this.ringingAlarm,
    this.matchedMedicines = const [],
    this.medicinesNamesOptionsLoadingState = OptionsLoadingState.loading,
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
          selectedDoctorName: null,
          medicalComplaints: const [],
          medicinesNames: const [],
          medicineForms: const [],
          medicalDoses: const [],
          medicinesBasicInfo: const [],
          dosageFrequencies: const [],
          allUsageCategories: const [],
          allDurationsBasedOnCategory: const [],
          medicineId: '',
          updatedDocumentId: '',
          selectedAlarmTime: null,
          ringingAlarm: null,
          matchedMedicines: const [],
          medicinesNamesOptionsLoadingState: OptionsLoadingState.loading,
        );

  MedicinesDataEntryState copyWith({
    RequestStatus? medicinesDataEntryStatus,
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
    String? selectedDoctorName,
    List<MedicalComplaint>? medicalComplaints,
    List<String>? medicinesNames,
    List<String>? medicineForms,
    List<String>? medicalDoses,
    String? medicineId,
    List<MedicineBasicInfoModel>? medicinesBasicInfo,
    List<String>? dosageFrequencies,
    List<String>? allUsageCategories,
    List<String>? allDurationsBasedOnCategory,
    String? selectedAlarmTime,
    String? updatedDocumentId,
    AlarmSettings? ringingAlarm,
    List<MatchedMedicineModel>? matchedMedicines,
    bool? isLoading,
    OptionsLoadingState? medicinesNamesOptionsLoadingState,
  }) {
    return MedicinesDataEntryState(
      medicinesDataEntryStatus:
          medicinesDataEntryStatus ?? this.medicinesDataEntryStatus,
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
      selectedDoctorName: selectedDoctorName ?? this.selectedDoctorName,
      medicalComplaints: medicalComplaints ?? this.medicalComplaints,
      medicinesNames: medicinesNames ?? this.medicinesNames,
      medicineForms: medicineForms ?? this.medicineForms,
      medicalDoses: medicalDoses ?? this.medicalDoses,
      medicineId: medicineId ?? this.medicineId,
      medicinesBasicInfo: medicinesBasicInfo ?? this.medicinesBasicInfo,
      dosageFrequencies: dosageFrequencies ?? this.dosageFrequencies,
      allUsageCategories: allUsageCategories ?? this.allUsageCategories,
      allDurationsBasedOnCategory:
          allDurationsBasedOnCategory ?? this.allDurationsBasedOnCategory,
      selectedAlarmTime: selectedAlarmTime ?? this.selectedAlarmTime,
      updatedDocumentId: updatedDocumentId ?? this.updatedDocumentId,
      ringingAlarm: ringingAlarm ?? this.ringingAlarm,
      matchedMedicines: matchedMedicines ?? this.matchedMedicines,
      medicinesNamesOptionsLoadingState: medicinesNamesOptionsLoadingState ??
          this.medicinesNamesOptionsLoadingState,
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
        selectedDoctorName,
        medicalComplaints,
        medicinesNames,
        medicineForms,
        medicalDoses,
        medicineId,
        medicinesBasicInfo,
        dosageFrequencies,
        allUsageCategories,
        allDurationsBasedOnCategory,
        selectedAlarmTime,
        updatedDocumentId,
        ringingAlarm,
        matchedMedicines,
        medicinesNamesOptionsLoadingState,
      ];
}
