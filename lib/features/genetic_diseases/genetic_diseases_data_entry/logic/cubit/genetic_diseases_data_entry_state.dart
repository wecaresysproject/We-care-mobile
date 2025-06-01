import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';

@immutable
class PersonalGeneticDiseasesDataEntryState extends Equatable {
  final RequestStatus medicinesDataEntryStatus;
  final String? diagnosisDate; // تاريخ التشخيص
  final String? geneticDiseaseCategory; //فئة المرض الوراثي
  final String? selectedDiseaseStatus; // حالة المرض
  final String? selectedDiseaseName; // الوراثي المرض
  final List<String> diseasesClassfications;
  final List<String> diseasesStatuses; // حالة المرض
  final List<String> diseasesNames;
  final String? selectedMedicalForm;
  final String? selectedDose;
  final String? selectedNoOfDose;
  final String? doseDuration;
  final String? timePeriods;
  final String? selectedChronicDisease;
  final String? selectedDoctorName;
  final bool isFormValidated;
  final List<NewGeneticDiseaseModel> geneticDiseases;
  final List<String> doctorNames;
  final List<String> countriesNames;
  final String medicineId;
  final String updatedDocumentId;
  final List<MedicineBasicInfoModel>? medicinesBasicInfo;
  final List<String> dosageFrequencies; // عدد مرات الجرعات
  final List<String> allUsageCategories; // مدة الاستخدام
  final List<String> allDurationsBasedOnCategory; // المدد الزمنيه
  final bool isEditMode;
  final String message; // error or success message
  final UploadImageRequestStatus firstImageRequestStatus;
  final UploadImageRequestStatus secondImageRequestStatus;
  final UploadReportRequestStatus reportRequestStatus;
  final String? firstImageUploadedUrl;
  final String? secondImageUploadedUrl;
  final String? reportUploadedUrl;

  const PersonalGeneticDiseasesDataEntryState({
    this.medicinesDataEntryStatus = RequestStatus.initial,
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.diagnosisDate,
    this.geneticDiseaseCategory,
    this.selectedDiseaseStatus,
    this.selectedDiseaseName,
    this.diseasesClassfications = const [],
    this.diseasesStatuses = const [],
    this.diseasesNames = const [],
    this.selectedMedicalForm,
    this.selectedDose,
    this.selectedNoOfDose,
    this.doseDuration,
    this.timePeriods,
    this.selectedChronicDisease,
    this.selectedDoctorName,
    this.geneticDiseases = const [],
    this.countriesNames = const [],
    this.doctorNames = const [],
    this.medicinesBasicInfo = const [],
    this.dosageFrequencies = const [],
    this.allUsageCategories = const [],
    this.allDurationsBasedOnCategory = const [],
    this.firstImageRequestStatus = UploadImageRequestStatus.initial,
    this.secondImageRequestStatus = UploadImageRequestStatus.initial,
    this.reportRequestStatus = UploadReportRequestStatus.initial,
    this.firstImageUploadedUrl,
    this.secondImageUploadedUrl,
    this.reportUploadedUrl,
    this.medicineId = '',
    this.updatedDocumentId = '',
  }) : super();

  const PersonalGeneticDiseasesDataEntryState.initialState()
      : this(
          medicinesDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          message: '',
          isEditMode: false,
          diagnosisDate: null,
          geneticDiseaseCategory: null,
          selectedDiseaseStatus: null,
          selectedDiseaseName: null,
          diseasesClassfications: const [],
          diseasesStatuses: const [],
          diseasesNames: const [],
          firstImageRequestStatus: UploadImageRequestStatus.initial,
          secondImageRequestStatus: UploadImageRequestStatus.initial,
          reportRequestStatus: UploadReportRequestStatus.initial,
          firstImageUploadedUrl: null,
          secondImageUploadedUrl: null,
          reportUploadedUrl: null,
          selectedMedicalForm: null,
          selectedDose: null,
          selectedNoOfDose: null,
          doseDuration: null,
          timePeriods: null,
          selectedChronicDisease: null,
          selectedDoctorName: null,
          geneticDiseases: const [],
          doctorNames: const [],
          countriesNames: const [],
          medicinesBasicInfo: const [],
          dosageFrequencies: const [],
          allUsageCategories: const [],
          allDurationsBasedOnCategory: const [],
          medicineId: '',
          updatedDocumentId: '',
        );

  PersonalGeneticDiseasesDataEntryState copyWith({
    RequestStatus? medicinesDataEntryStatus,
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    String? diagnosisDate,
    String? geneticDiseaseCategory,
    String? selectedDiseaseStatus,
    String? selectedDiseaseName, // Added for consistency
    String? firstImageUploadedUrl,
    String? secondImageUploadedUrl,
    String? reportUploadedUrl,
    UploadImageRequestStatus? firstImageRequestStatus,
    UploadImageRequestStatus? secondImageRequestStatus,
    UploadReportRequestStatus? reportRequestStatus,
    String? selectedMedicalForm,
    String? selectedDose,
    String? selectedNoOfDose,
    String? doseDuration,
    String? timePeriods,
    String? selectedChronicDisease,
    String? selectedDoctorName,
    List<NewGeneticDiseaseModel>? geneticDiseases,
    List<String>? doctorNames,
    List<String>? countriesNames,
    List<String>? diseasesClassfications,
    List<String>? diseasesStatuses,
    List<String>? diseasesNames,
    String? medicineId,
    List<MedicineBasicInfoModel>? medicinesBasicInfo,
    List<String>? dosageFrequencies,
    List<String>? allUsageCategories,
    List<String>? allDurationsBasedOnCategory,
    String? updatedDocumentId,
    bool? isLoading,
  }) {
    return PersonalGeneticDiseasesDataEntryState(
      medicinesDataEntryStatus:
          medicinesDataEntryStatus ?? this.medicinesDataEntryStatus,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      geneticDiseaseCategory:
          geneticDiseaseCategory ?? this.geneticDiseaseCategory,
      selectedDiseaseStatus:
          selectedDiseaseStatus ?? this.selectedDiseaseStatus,
      selectedDiseaseName: selectedDiseaseName ?? this.selectedDiseaseName,
      diseasesClassfications:
          diseasesClassfications ?? this.diseasesClassfications,
      diseasesStatuses: diseasesStatuses ?? this.diseasesStatuses,
      firstImageUploadedUrl:
          firstImageUploadedUrl ?? this.firstImageUploadedUrl,
      secondImageUploadedUrl:
          secondImageUploadedUrl ?? this.secondImageUploadedUrl,
      reportUploadedUrl: reportUploadedUrl ?? this.reportUploadedUrl,
      firstImageRequestStatus:
          firstImageRequestStatus ?? this.firstImageRequestStatus,
      secondImageRequestStatus:
          secondImageRequestStatus ?? this.secondImageRequestStatus,
      reportRequestStatus: reportRequestStatus ?? this.reportRequestStatus,
      diseasesNames: diseasesNames ?? this.diseasesNames,
      selectedMedicalForm: selectedMedicalForm ?? this.selectedMedicalForm,
      selectedDose: selectedDose ?? this.selectedDose,
      selectedNoOfDose: selectedNoOfDose ?? this.selectedNoOfDose,
      doseDuration: doseDuration ?? this.doseDuration,
      timePeriods: timePeriods ?? this.timePeriods,
      selectedChronicDisease:
          selectedChronicDisease ?? this.selectedChronicDisease,
      selectedDoctorName: selectedDoctorName ?? this.selectedDoctorName,
      geneticDiseases: geneticDiseases ?? this.geneticDiseases,
      doctorNames: doctorNames ?? this.doctorNames,
      countriesNames: countriesNames ?? this.countriesNames,
      medicineId: medicineId ?? this.medicineId,
      medicinesBasicInfo: medicinesBasicInfo ?? this.medicinesBasicInfo,
      dosageFrequencies: dosageFrequencies ?? this.dosageFrequencies,
      allUsageCategories: allUsageCategories ?? this.allUsageCategories,
      allDurationsBasedOnCategory:
          allDurationsBasedOnCategory ?? this.allDurationsBasedOnCategory,
      updatedDocumentId: updatedDocumentId ?? this.updatedDocumentId,
    );
  }

  @override
  List<Object?> get props => [
        medicinesDataEntryStatus,
        isFormValidated,
        message,
        isEditMode,
        diagnosisDate,
        geneticDiseaseCategory,
        diseasesClassfications,
        diseasesStatuses,
        diseasesNames,
        selectedDiseaseStatus,
        selectedDiseaseName,
        firstImageUploadedUrl,
        secondImageUploadedUrl,
        reportUploadedUrl,
        firstImageRequestStatus,
        secondImageRequestStatus,
        reportRequestStatus,
        selectedMedicalForm,
        selectedDose,
        selectedNoOfDose,
        doseDuration,
        timePeriods,
        selectedChronicDisease,
        selectedDoctorName,
        geneticDiseases,
        doctorNames,
        countriesNames,
        medicineId,
        medicinesBasicInfo,
        dosageFrequencies,
        allUsageCategories,
        allDurationsBasedOnCategory,
        updatedDocumentId,
      ];
}
