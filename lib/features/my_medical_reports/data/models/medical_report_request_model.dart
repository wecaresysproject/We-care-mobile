import 'package:json_annotation/json_annotation.dart';

part 'medical_report_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicalReportRequestModel {
  final MedicalReportSelections selections;

  MedicalReportRequestModel({required this.selections});

  factory MedicalReportRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportRequestModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MedicalReportSelections {
  @JsonKey(name: 'basicInformation')
  final BasicInformationSelection? basicInformation;

  @JsonKey(name: 'medications')
  final MedicineCategorySelectionRequestBody? medications;

  @JsonKey(name: 'chronicDiseases')
  final ChronicDiseasesSelectionRequestBody? chronicDiseases;

  @JsonKey(name: 'emergencyComplaints')
  final UrgentComplaintsSelectionRequestBody? urgentComplaints;

  @JsonKey(name: 'Radiology')
  final RadiologySelectionRequestBody? radiology;

  @JsonKey(name: 'vitalSigns')
  final VitalSignsSelectionRequestBody? vitalSigns;

  @JsonKey(name: 'LabTests')
  final MedicalTestsSelectionRequestBody? medicalTests;

  @JsonKey(name: 'PreDescriptions')
  final PrescriptionsSelectionRequestBody? prescriptions;

  @JsonKey(name: 'SurgeryEntries')
  final SurgeriesSelectionRequestBody? surgeries;

  @JsonKey(name: 'geneticDiseases')
  final GeneticDiseasesSelectionRequestBody? geneticDiseases;

  @JsonKey(name: 'Allergy')
  final AllergiesSelectionRequestBody? allergies;

  @JsonKey(name: 'eyes')
  final EyesSelectionRequestBody? eyes;

  @JsonKey(name: 'teeth')
  final TeethSelectionRequestBody? teeth;

  @JsonKey(name: 'nutritionTracking')
  final SmartNutritionalAnalyzerSelectionRequestBody? smartNutritionalAnalyzer;

  @JsonKey(name: 'supplements')
  final SupplementsSelectionRequestBody? supplements;

  @JsonKey(name: 'physicalActivity')
  final PhysicalActivitySelectionRequestBody? sportsActivity;

  @JsonKey(name: 'mentalDiseases')
  final MentalDiseasesSelectionRequestBody? mentalDiseases;

  MedicalReportSelections({
    this.basicInformation,
    this.medications,
    this.chronicDiseases,
    this.urgentComplaints,
    this.radiology,
    this.vitalSigns,
    this.medicalTests,
    this.prescriptions,
    this.surgeries,
    this.geneticDiseases,
    this.allergies,
    this.eyes,
    this.teeth,
    this.smartNutritionalAnalyzer,
    this.supplements,
    this.sportsActivity,
    this.mentalDiseases,
  });

  factory MedicalReportSelections.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportSelectionsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportSelectionsToJson(this);
}

@JsonSerializable()
class PhysicalActivitySelectionRequestBody {
  final bool getAll;
  @JsonKey(name: 'dateRange')
  final List<String> dateRanges;

  PhysicalActivitySelectionRequestBody({
    required this.getAll,
    required this.dateRanges,
  });

  factory PhysicalActivitySelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$PhysicalActivitySelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PhysicalActivitySelectionRequestBodyToJson(this);
}

@JsonSerializable()
class MentalDiseasesSelectionRequestBody {
  final bool getAll;
  final List<String> mentalIllnessTypes;
  final List<String> psychologicalEmergencies;

  MentalDiseasesSelectionRequestBody({
    required this.getAll,
    required this.mentalIllnessTypes,
    required this.psychologicalEmergencies,
  });

  factory MentalDiseasesSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$MentalDiseasesSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MentalDiseasesSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class SupplementsSelectionRequestBody {
  final bool getAll;
  final List<String> years;
  final List<String> supplementNames;

  SupplementsSelectionRequestBody({
    required this.getAll,
    required this.years,
    required this.supplementNames,
  });

  factory SupplementsSelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SupplementsSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SupplementsSelectionRequestBodyToJson(this);
}

// ... existing classes ...

@JsonSerializable()
class SmartNutritionalAnalyzerSelectionRequestBody {
  final bool getAll;
  @JsonKey(name: "ranges")
  final List<String> dateRanges;

  SmartNutritionalAnalyzerSelectionRequestBody({
    required this.getAll,
    required this.dateRanges,
  });

  factory SmartNutritionalAnalyzerSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$SmartNutritionalAnalyzerSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SmartNutritionalAnalyzerSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class BasicInformationSelection {
  final bool getAll;
  @JsonKey(name: 'specificFields')
  final List<String> selectedValues;

  BasicInformationSelection({
    required this.getAll,
    required this.selectedValues,
  });

  factory BasicInformationSelection.fromJson(Map<String, dynamic> json) =>
      _$BasicInformationSelectionFromJson(json);

  Map<String, dynamic> toJson() => _$BasicInformationSelectionToJson(this);
}

@JsonSerializable()
class VitalSignsSelectionRequestBody {
  final bool getAll;
  @JsonKey(name: 'specificFields')
  final List<String> selectedValues;

  VitalSignsSelectionRequestBody({
    required this.getAll,
    required this.selectedValues,
  });

  factory VitalSignsSelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VitalSignsSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignsSelectionRequestBodyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MedicineCategorySelectionRequestBody {
  final bool getAll;
  final MedicineDetailsSelection currentMedicines;
  final MedicineDetailsSelection expiredLast3Months;

  MedicineCategorySelectionRequestBody({
    required this.getAll,
    required this.currentMedicines,
    required this.expiredLast3Months,
  });

  factory MedicineCategorySelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$MedicineCategorySelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MedicineCategorySelectionRequestBodyToJson(this);
}

@JsonSerializable()
class MedicineDetailsSelection {
  final List<String> drugNames;

  MedicineDetailsSelection({
    required this.drugNames,
  });

  factory MedicineDetailsSelection.fromJson(Map<String, dynamic> json) =>
      _$MedicineDetailsSelectionFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineDetailsSelectionToJson(this);
}

@JsonSerializable()
class ChronicDiseasesSelectionRequestBody {
  final bool getAll;
  final List<String> diseases;

  ChronicDiseasesSelectionRequestBody({
    required this.getAll,
    required this.diseases,
  });

  factory ChronicDiseasesSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$ChronicDiseasesSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChronicDiseasesSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class UrgentComplaintsSelectionRequestBody {
  final bool getAll;
  final bool attachImages;
  final List<String> years;
  final List<String> organs;
  final List<String> complaints;
  final List<String> otherComplaints;

  UrgentComplaintsSelectionRequestBody({
    required this.getAll,
    required this.attachImages,
    required this.years,
    required this.organs,
    required this.complaints,
    required this.otherComplaints,
  });

  factory UrgentComplaintsSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$UrgentComplaintsSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UrgentComplaintsSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class RadiologySelectionRequestBody {
  final bool getAll;
  final bool attachImages;
  final List<String> years;
  @JsonKey(name: 'BodyParts')
  final List<String> regions;
  @JsonKey(name: 'RadioTypes')
  final List<String> types;

  RadiologySelectionRequestBody({
    required this.getAll,
    required this.attachImages,
    required this.years,
    required this.regions,
    required this.types,
  });

  factory RadiologySelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RadiologySelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RadiologySelectionRequestBodyToJson(this);
}

@JsonSerializable()
class MedicalTestsSelectionRequestBody {
  final bool getAll;
  final List<String> years;
  @JsonKey(name: 'GroupName')
  final List<String> testGroups;

  MedicalTestsSelectionRequestBody({
    required this.getAll,
    required this.years,
    required this.testGroups,
  });

  factory MedicalTestsSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$MedicalTestsSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MedicalTestsSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class PrescriptionsSelectionRequestBody {
  final bool getAll;
  final List<String> years;
  @JsonKey(name: 'Specialties')
  final List<String> specialties;
  @JsonKey(name: 'Doctors')
  final List<String> doctorNames;

  PrescriptionsSelectionRequestBody({
    required this.getAll,
    required this.years,
    required this.specialties,
    required this.doctorNames,
  });

  factory PrescriptionsSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$PrescriptionsSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PrescriptionsSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class SurgeriesSelectionRequestBody {
  final bool getAll;
  final bool attachImages;
  final List<String> years;
  final List<String> surgeryNames;

  SurgeriesSelectionRequestBody({
    required this.getAll,
    required this.attachImages,
    required this.years,
    required this.surgeryNames,
  });

  factory SurgeriesSelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SurgeriesSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SurgeriesSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class GeneticDiseasesSelectionRequestBody {
  final bool getAll;
  final List<String> familyGeneticDiseases;
  final List<String> myExpectedGeneticDiseases;

  GeneticDiseasesSelectionRequestBody({
    required this.getAll,
    required this.familyGeneticDiseases,
    required this.myExpectedGeneticDiseases,
  });

  factory GeneticDiseasesSelectionRequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$GeneticDiseasesSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GeneticDiseasesSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class AllergiesSelectionRequestBody {
  final bool getAll;
  @JsonKey(name: "allergyTypes")
  final List<String> types;

  AllergiesSelectionRequestBody({
    required this.getAll,
    required this.types,
  });

  factory AllergiesSelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AllergiesSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AllergiesSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class EyesSelectionRequestBody {
  final bool getAll;
  @JsonKey(name: "AttachImages")
  final bool attachReport;
  @JsonKey(name: "needMedicalRecord")
  final bool attachMedicalTests;
  final List<String> years;
  final List<String> regions;
  final List<String> symptoms;
  final List<String> medicalProcedures;

  EyesSelectionRequestBody({
    required this.getAll,
    required this.attachReport,
    required this.attachMedicalTests,
    required this.years,
    required this.regions,
    required this.symptoms,
    required this.medicalProcedures,
  });

  factory EyesSelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$EyesSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EyesSelectionRequestBodyToJson(this);
}

@JsonSerializable()
class TeethSelectionRequestBody {
  final bool getAll;
  @JsonKey(name: "attachImages")
  final bool attachReport;
  final List<String> years;
  final List<String> teethNumbers;
  @JsonKey(name: "symptomTypes")
  final List<String> complaints;
  @JsonKey(name: "primaryProcedures")
  final List<String> medicalProcedures;

  TeethSelectionRequestBody({
    required this.getAll,
    required this.attachReport,
    required this.years,
    required this.teethNumbers,
    required this.complaints,
    required this.medicalProcedures,
  });

  factory TeethSelectionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$TeethSelectionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TeethSelectionRequestBodyToJson(this);
}
