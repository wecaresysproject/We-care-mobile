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
  final List<String> urgentComplaintsSelectedOtherComplaints;
  final bool urgentComplaintsAttachImages;
  final bool radiologyGetAll;
  final bool radiologyAttachImages;
  final List<String> radiologySelectedYears;
  final List<String> radiologySelectedRegions;
  final List<String> radiologySelectedTypes;
  final bool medicalTestsGetAll;
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
  final bool attachEyeMedicalTests;
  final List<String> eyesSelectedYears;
  final List<String> eyesSelectedRegions;
  final List<String> eyesSelectedSymptoms;
  final List<String> eyesSelectedMedicalProcedures;
  final bool dentalGetAll;
  final bool dentalAttachReport;
  final List<String> dentalSelectedYears;
  final List<String> dentalSelectedTeethNumbers;
  final List<String> dentalSelectedComplaints;
  final List<String> dentalSelectedMedicalProcedures;
  final bool smartNutritionGetAll;
  final List<String> smartNutritionSelectedReports;
  final bool supplementsGetAll;
  final List<String> supplementsSelectedYears;
  final List<String> supplementsSelectedNames;
  final bool physicalActivityGetAll;
  final List<String> physicalActivitySelectedReports;
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
    this.urgentComplaintsSelectedOtherComplaints = const [],
    this.urgentComplaintsAttachImages = false,
    this.radiologyGetAll = false,
    this.radiologyAttachImages = false,
    this.radiologySelectedYears = const [],
    this.radiologySelectedRegions = const [],
    this.radiologySelectedTypes = const [],
    this.medicalTestsGetAll = false,
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
    this.attachEyeMedicalTests = false,
    this.eyesSelectedYears = const [],
    this.eyesSelectedRegions = const [],
    this.eyesSelectedSymptoms = const [],
    this.eyesSelectedMedicalProcedures = const [],
    this.dentalGetAll = false,
    this.dentalAttachReport = false,
    this.dentalSelectedYears = const [],
    this.dentalSelectedTeethNumbers = const [],
    this.dentalSelectedComplaints = const [],
    this.dentalSelectedMedicalProcedures = const [],
    this.smartNutritionGetAll = false,
    this.smartNutritionSelectedReports = const [],
    this.supplementsGetAll = false,
    this.supplementsSelectedYears = const [],
    this.supplementsSelectedNames = const [],
    this.physicalActivityGetAll = false,
    this.physicalActivitySelectedReports = const [],
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
    List<String>? urgentComplaintsSelectedOtherComplaints,
    bool? urgentComplaintsAttachImages,
    bool? radiologyGetAll,
    bool? radiologyAttachImages,
    List<String>? radiologySelectedYears,
    List<String>? radiologySelectedRegions,
    List<String>? radiologySelectedTypes,
    bool? medicalTestsGetAll,
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
    bool? attachEyeMedicalTests,
    List<String>? eyesSelectedYears,
    List<String>? eyesSelectedRegions,
    List<String>? eyesSelectedSymptoms,
    List<String>? eyesSelectedMedicalProcedures,
    bool? dentalGetAll,
    bool? dentalAttachReport,
    List<String>? dentalSelectedYears,
    List<String>? dentalSelectedTeethNumbers,
    List<String>? dentalSelectedComplaints,
    List<String>? dentalSelectedMedicalProcedures,
    bool? smartNutritionGetAll,
    List<String>? smartNutritionSelectedReports,
    bool? supplementsGetAll,
    List<String>? supplementsSelectedYears,
    List<String>? supplementsSelectedNames,
    bool? physicalActivityGetAll,
    List<String>? physicalActivitySelectedReports,
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
      urgentComplaintsSelectedOtherComplaints:
          urgentComplaintsSelectedOtherComplaints ??
              this.urgentComplaintsSelectedOtherComplaints,
      urgentComplaintsAttachImages:
          urgentComplaintsAttachImages ?? this.urgentComplaintsAttachImages,
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
      attachEyeMedicalTests:
          attachEyeMedicalTests ?? this.attachEyeMedicalTests,
      eyesSelectedYears: eyesSelectedYears ?? this.eyesSelectedYears,
      eyesSelectedRegions: eyesSelectedRegions ?? this.eyesSelectedRegions,
      eyesSelectedSymptoms: eyesSelectedSymptoms ?? this.eyesSelectedSymptoms,
      eyesSelectedMedicalProcedures:
          eyesSelectedMedicalProcedures ?? this.eyesSelectedMedicalProcedures,
      dentalGetAll: dentalGetAll ?? this.dentalGetAll,
      dentalAttachReport: dentalAttachReport ?? this.dentalAttachReport,
      dentalSelectedYears: dentalSelectedYears ?? this.dentalSelectedYears,
      dentalSelectedTeethNumbers:
          dentalSelectedTeethNumbers ?? this.dentalSelectedTeethNumbers,
      dentalSelectedComplaints:
          dentalSelectedComplaints ?? this.dentalSelectedComplaints,
      dentalSelectedMedicalProcedures: dentalSelectedMedicalProcedures ??
          this.dentalSelectedMedicalProcedures,
      smartNutritionGetAll: smartNutritionGetAll ?? this.smartNutritionGetAll,
      smartNutritionSelectedReports:
          smartNutritionSelectedReports ?? this.smartNutritionSelectedReports,
      supplementsGetAll: supplementsGetAll ?? this.supplementsGetAll,
      supplementsSelectedYears:
          supplementsSelectedYears ?? this.supplementsSelectedYears,
      supplementsSelectedNames:
          supplementsSelectedNames ?? this.supplementsSelectedNames,
      physicalActivityGetAll:
          physicalActivityGetAll ?? this.physicalActivityGetAll,
      physicalActivitySelectedReports: physicalActivitySelectedReports ??
          this.physicalActivitySelectedReports,
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
        urgentComplaintsSelectedOtherComplaints,
        urgentComplaintsAttachImages,
        radiologyGetAll,
        radiologyAttachImages,
        radiologySelectedYears,
        radiologySelectedRegions,
        radiologySelectedTypes,
        medicalTestsGetAll,
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
        attachEyeMedicalTests,
        eyesSelectedYears,
        eyesSelectedRegions,
        eyesSelectedSymptoms,
        eyesSelectedMedicalProcedures,
        dentalGetAll,
        dentalAttachReport,
        dentalSelectedYears,
        dentalSelectedTeethNumbers,
        dentalSelectedComplaints,
        dentalSelectedMedicalProcedures,
        smartNutritionGetAll,
        smartNutritionSelectedReports,
        supplementsGetAll,
        supplementsSelectedYears,
        supplementsSelectedNames,
        physicalActivityGetAll,
        physicalActivitySelectedReports,
        medicalReportData,
        categoryFilters,
      ];
}
