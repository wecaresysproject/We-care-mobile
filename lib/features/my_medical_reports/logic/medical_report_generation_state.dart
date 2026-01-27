part of 'medical_report_generation_cubit.dart';

class MedicalReportGenerationState extends Equatable {
  final RequestStatus status;
  final Map<String, RequestStatus> categoryFiltersStatus;
  final String message;
  final bool basicInfoGetAll;
  final List<String> basicInfoSelectedValues;
  final List<String> vitalSignsSelectedValues;
  final bool vitalSignsGetAll;
  final bool medicineGetAll;
  final List<String> medicineCurrentNames;
  final List<String> medicineExpiredNames;
  final bool chronicDiseasesGetAll;
  final List<String> chronicDiseasesSelectedValues;
  final bool urgentComplaintsGetAll;
  final List<String> urgentComplaintsSelectedYears;
  final List<String> urgentComplaintsSelectedOrgans;
  final List<String> urgentComplaintsSelectedComplaints;
  final bool radiologyGetAll;
  final bool radiologyAttachImages;
  final List<String> radiologySelectedYears;
  final List<String> radiologySelectedRegions;
  final List<String> radiologySelectedTypes;
  final bool medicalTestsGetAll;
  final bool medicalTestsAttachImages;
  final List<String> medicalTestsSelectedYears;
  final List<String> medicalTestsSelectedTestGroups;
  final bool prescriptionsGetAll;
  final bool prescriptionsAttachImages;
  final List<String> prescriptionsSelectedYears;
  final List<String> prescriptionsSelectedSpecialties;
  final List<String> prescriptionsSelectedDoctorNames;
  final bool surgeriesGetAll;
  final bool surgeriesAttachReport;
  final List<String> surgeriesSelectedNames;
  final List<String> surgeriesSelectedYears;
  final bool geneticDiseasesGetAll;
  final List<String> geneticDiseasesSelectedValues;
  final bool allergiesGetAll;
  final List<String> allergiesSelectedTypes;
  final bool eyesGetAll;
  final bool eyesAttachReport;
  final List<String> eyesSelectedYears;
  final List<String> eyesSelectedRegions;
  final List<String> eyesSelectedSymptoms;
  final List<String> eyesSelectedMedicalProcedures;
  final MedicalReportResponseModel? medicalReportData;
  final Map<String, MedicalReportFilterResponseModel> categoryFilters;

  const MedicalReportGenerationState({
    this.status = RequestStatus.initial,
    this.categoryFiltersStatus = const {},
    this.message = '',
    this.basicInfoGetAll = false,
    this.basicInfoSelectedValues = const [],
    this.medicineGetAll = false,
    this.vitalSignsGetAll = false,
    this.vitalSignsSelectedValues = const [],
    this.medicineCurrentNames = const [],
    this.medicineExpiredNames = const [],
    this.chronicDiseasesGetAll = false,
    this.chronicDiseasesSelectedValues = const [],
    this.urgentComplaintsGetAll = false,
    this.urgentComplaintsSelectedYears = const [],
    this.urgentComplaintsSelectedOrgans = const [],
    this.urgentComplaintsSelectedComplaints = const [],
    this.radiologyGetAll = false,
    this.radiologyAttachImages = false,
    this.radiologySelectedYears = const [],
    this.radiologySelectedRegions = const [],
    this.radiologySelectedTypes = const [],
    this.medicalTestsGetAll = false,
    this.medicalTestsAttachImages = false,
    this.medicalTestsSelectedYears = const [],
    this.medicalTestsSelectedTestGroups = const [],
    this.prescriptionsGetAll = false,
    this.prescriptionsAttachImages = false,
    this.prescriptionsSelectedYears = const [],
    this.prescriptionsSelectedSpecialties = const [],
    this.prescriptionsSelectedDoctorNames = const [],
    this.surgeriesGetAll = false,
    this.surgeriesAttachReport = false,
    this.surgeriesSelectedNames = const [],
    this.surgeriesSelectedYears = const [],
    this.geneticDiseasesGetAll = false,
    this.geneticDiseasesSelectedValues = const [],
    this.allergiesGetAll = false,
    this.allergiesSelectedTypes = const [],
    this.eyesGetAll = false,
    this.eyesAttachReport = false,
    this.eyesSelectedYears = const [],
    this.eyesSelectedRegions = const [],
    this.eyesSelectedSymptoms = const [],
    this.eyesSelectedMedicalProcedures = const [],
    this.medicalReportData,
    this.categoryFilters = const {},
  });

  MedicalReportGenerationState copyWith({
    RequestStatus? status,
    Map<String, RequestStatus>? categoryFiltersStatus,
    String? message,
    bool? basicInfoGetAll,
    List<String>? basicInfoSelectedValues,
    bool? medicineGetAll,
    bool? vitalSignsGetAll,
    List<String>? vitalSignsSelectedValues,
    List<String>? medicineCurrentNames,
    List<String>? medicineExpiredNames,
    bool? chronicDiseasesGetAll,
    List<String>? chronicDiseasesSelectedValues,
    bool? urgentComplaintsGetAll,
    List<String>? urgentComplaintsSelectedYears,
    List<String>? urgentComplaintsSelectedOrgans,
    List<String>? urgentComplaintsSelectedComplaints,
    bool? radiologyGetAll,
    bool? radiologyAttachImages,
    List<String>? radiologySelectedYears,
    List<String>? radiologySelectedRegions,
    List<String>? radiologySelectedTypes,
    bool? medicalTestsGetAll,
    bool? medicalTestsAttachImages,
    List<String>? medicalTestsSelectedYears,
    List<String>? medicalTestsSelectedTestGroups,
    bool? prescriptionsGetAll,
    bool? prescriptionsAttachImages,
    List<String>? prescriptionsSelectedYears,
    List<String>? prescriptionsSelectedSpecialties,
    List<String>? prescriptionsSelectedDoctorNames,
    bool? surgeriesGetAll,
    bool? surgeriesAttachReport,
    List<String>? surgeriesSelectedNames,
    List<String>? surgeriesSelectedYears,
    bool? geneticDiseasesGetAll,
    List<String>? geneticDiseasesSelectedValues,
    bool? allergiesGetAll,
    List<String>? allergiesSelectedTypes,
    bool? eyesGetAll,
    bool? eyesAttachReport,
    List<String>? eyesSelectedYears,
    List<String>? eyesSelectedRegions,
    List<String>? eyesSelectedSymptoms,
    List<String>? eyesSelectedMedicalProcedures,
    MedicalReportResponseModel? medicalReportData,
    Map<String, MedicalReportFilterResponseModel>? categoryFilters,
  }) {
    return MedicalReportGenerationState(
      status: status ?? this.status,
      categoryFiltersStatus:
          categoryFiltersStatus ?? this.categoryFiltersStatus,
      message: message ?? this.message,
      basicInfoGetAll: basicInfoGetAll ?? this.basicInfoGetAll,
      basicInfoSelectedValues:
          basicInfoSelectedValues ?? this.basicInfoSelectedValues,
      medicineGetAll: medicineGetAll ?? this.medicineGetAll,
      vitalSignsGetAll: vitalSignsGetAll ?? this.vitalSignsGetAll,
      vitalSignsSelectedValues:
          vitalSignsSelectedValues ?? this.vitalSignsSelectedValues,
      medicineCurrentNames: medicineCurrentNames ?? this.medicineCurrentNames,
      medicineExpiredNames: medicineExpiredNames ?? this.medicineExpiredNames,
      chronicDiseasesGetAll:
          chronicDiseasesGetAll ?? this.chronicDiseasesGetAll,
      chronicDiseasesSelectedValues:
          chronicDiseasesSelectedValues ?? this.chronicDiseasesSelectedValues,
      urgentComplaintsGetAll:
          urgentComplaintsGetAll ?? this.urgentComplaintsGetAll,
      urgentComplaintsSelectedYears:
          urgentComplaintsSelectedYears ?? this.urgentComplaintsSelectedYears,
      urgentComplaintsSelectedOrgans:
          urgentComplaintsSelectedOrgans ?? this.urgentComplaintsSelectedOrgans,
      urgentComplaintsSelectedComplaints: urgentComplaintsSelectedComplaints ??
          this.urgentComplaintsSelectedComplaints,
      radiologyGetAll: radiologyGetAll ?? this.radiologyGetAll,
      radiologyAttachImages:
          radiologyAttachImages ?? this.radiologyAttachImages,
      radiologySelectedYears:
          radiologySelectedYears ?? this.radiologySelectedYears,
      radiologySelectedRegions:
          radiologySelectedRegions ?? this.radiologySelectedRegions,
      radiologySelectedTypes:
          radiologySelectedTypes ?? this.radiologySelectedTypes,
      medicalTestsGetAll: medicalTestsGetAll ?? this.medicalTestsGetAll,
      medicalTestsAttachImages:
          medicalTestsAttachImages ?? this.medicalTestsAttachImages,
      medicalTestsSelectedYears:
          medicalTestsSelectedYears ?? this.medicalTestsSelectedYears,
      medicalTestsSelectedTestGroups:
          medicalTestsSelectedTestGroups ?? this.medicalTestsSelectedTestGroups,
      prescriptionsGetAll: prescriptionsGetAll ?? this.prescriptionsGetAll,
      prescriptionsAttachImages:
          prescriptionsAttachImages ?? this.prescriptionsAttachImages,
      prescriptionsSelectedYears:
          prescriptionsSelectedYears ?? this.prescriptionsSelectedYears,
      prescriptionsSelectedSpecialties: prescriptionsSelectedSpecialties ??
          this.prescriptionsSelectedSpecialties,
      prescriptionsSelectedDoctorNames: prescriptionsSelectedDoctorNames ??
          this.prescriptionsSelectedDoctorNames,
      surgeriesGetAll: surgeriesGetAll ?? this.surgeriesGetAll,
      surgeriesAttachReport:
          surgeriesAttachReport ?? this.surgeriesAttachReport,
      surgeriesSelectedNames:
          surgeriesSelectedNames ?? this.surgeriesSelectedNames,
      surgeriesSelectedYears:
          surgeriesSelectedYears ?? this.surgeriesSelectedYears,
      geneticDiseasesGetAll:
          geneticDiseasesGetAll ?? this.geneticDiseasesGetAll,
      geneticDiseasesSelectedValues:
          geneticDiseasesSelectedValues ?? this.geneticDiseasesSelectedValues,
      allergiesGetAll: allergiesGetAll ?? this.allergiesGetAll,
      allergiesSelectedTypes:
          allergiesSelectedTypes ?? this.allergiesSelectedTypes,
      eyesGetAll: eyesGetAll ?? this.eyesGetAll,
      eyesAttachReport: eyesAttachReport ?? this.eyesAttachReport,
      eyesSelectedYears: eyesSelectedYears ?? this.eyesSelectedYears,
      eyesSelectedRegions: eyesSelectedRegions ?? this.eyesSelectedRegions,
      eyesSelectedSymptoms: eyesSelectedSymptoms ?? this.eyesSelectedSymptoms,
      eyesSelectedMedicalProcedures:
          eyesSelectedMedicalProcedures ?? this.eyesSelectedMedicalProcedures,
      medicalReportData: medicalReportData ?? this.medicalReportData,
      categoryFilters: categoryFilters ?? this.categoryFilters,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categoryFiltersStatus,
        message,
        basicInfoGetAll,
        basicInfoSelectedValues,
        medicineGetAll,
        vitalSignsGetAll,
        vitalSignsSelectedValues,
        medicineCurrentNames,
        medicineExpiredNames,
        chronicDiseasesGetAll,
        chronicDiseasesSelectedValues,
        urgentComplaintsGetAll,
        urgentComplaintsSelectedYears,
        urgentComplaintsSelectedOrgans,
        urgentComplaintsSelectedComplaints,
        radiologyGetAll,
        radiologyAttachImages,
        radiologySelectedYears,
        radiologySelectedRegions,
        radiologySelectedTypes,
        medicalTestsGetAll,
        medicalTestsAttachImages,
        medicalTestsSelectedYears,
        medicalTestsSelectedTestGroups,
        prescriptionsGetAll,
        prescriptionsAttachImages,
        prescriptionsSelectedYears,
        prescriptionsSelectedSpecialties,
        prescriptionsSelectedDoctorNames,
        surgeriesGetAll,
        surgeriesAttachReport,
        surgeriesSelectedNames,
        surgeriesSelectedYears,
        geneticDiseasesGetAll,
        geneticDiseasesSelectedValues,
        allergiesGetAll,
        allergiesSelectedTypes,
        eyesGetAll,
        eyesAttachReport,
        eyesSelectedYears,
        eyesSelectedRegions,
        eyesSelectedSymptoms,
        eyesSelectedMedicalProcedures,
        medicalReportData,
        categoryFilters,
      ];
}
