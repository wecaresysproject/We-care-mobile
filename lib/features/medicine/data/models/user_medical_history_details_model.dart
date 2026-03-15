import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_medical_history_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserMedicalHistoryDetailsModel extends Equatable {
  final List<BasicInformationModel>? basicInformation;
  final List<VitalSignModel>? vitalSigns;
  final MedicationsModuleModel? medicationsModule;
  final List<ChronicDiseaseModel>? chronicDiseases;
  final ComplaintsModuleModel? complaintsModule;
  final List<PreDescriptionModel>? preDescriptions;
  final List<MedicalTestModel>? medicalTests;
  final List<RadiologyModel>? radiology;
  final List<SurgeryEntryModel>? surgeryEntries;
  final GeneticDiseasesModuleModel? geneticDiseases;
  final List<AllergyModel>? allergy;
  final EyeModuleModel? eyeModule;
  final TeethModuleModel? teethModule;
  final MentalIllnessModuleModel? mentalIllnessModule;
  final List<NutritionTrackingModuleModel>? nutritionTrackingModule;
  final List<PhysicalActivityModuleModel>? physicalActivityModule;
  final SupplementsModuleModel? supplementsModule;

  const UserMedicalHistoryDetailsModel({
    this.basicInformation,
    this.vitalSigns,
    this.medicationsModule,
    this.chronicDiseases,
    this.complaintsModule,
    this.preDescriptions,
    this.medicalTests,
    this.radiology,
    this.surgeryEntries,
    this.geneticDiseases,
    this.allergy,
    this.eyeModule,
    this.teethModule,
    this.mentalIllnessModule,
    this.nutritionTrackingModule,
    this.physicalActivityModule,
    this.supplementsModule,
  });

  factory UserMedicalHistoryDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$UserMedicalHistoryDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserMedicalHistoryDetailsModelToJson(this);

  @override
  List<Object?> get props => [
        basicInformation,
        vitalSigns,
        medicationsModule,
        chronicDiseases,
        complaintsModule,
        preDescriptions,
        medicalTests,
        radiology,
        surgeryEntries,
        geneticDiseases,
        allergy,
        eyeModule,
        teethModule,
        mentalIllnessModule,
        nutritionTrackingModule,
        physicalActivityModule,
        supplementsModule,
      ];
}

@JsonSerializable()
class BasicInformationModel extends Equatable {
  final String? label;
  final dynamic value;

  const BasicInformationModel({this.label, this.value});

  factory BasicInformationModel.fromJson(Map<String, dynamic> json) =>
      _$BasicInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$BasicInformationModelToJson(this);

  @override
  List<Object?> get props => [label, value];
}

@JsonSerializable(explicitToJson: true)
class VitalSignModel extends Equatable {
  final String? categoryName;
  final List<VitalSignReadingModel>? reading;

  const VitalSignModel({this.categoryName, this.reading});

  factory VitalSignModel.fromJson(Map<String, dynamic> json) =>
      _$VitalSignModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignModelToJson(this);

  @override
  List<Object?> get props => [categoryName, reading];
}

@JsonSerializable()
class VitalSignReadingModel extends Equatable {
  final String? min;
  final String? max;
  final String? date;

  const VitalSignReadingModel({this.min, this.max, this.date});

  factory VitalSignReadingModel.fromJson(Map<String, dynamic> json) =>
      _$VitalSignReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignReadingModelToJson(this);

  @override
  List<Object?> get props => [min, max, date];
}

@JsonSerializable(explicitToJson: true)
class MedicationsModuleModel extends Equatable {
  final List<MedicationModel>? currentMedications;
  final List<MedicationModel>? expiredLast90Days;

  const MedicationsModuleModel({
    this.currentMedications,
    this.expiredLast90Days,
  });

  factory MedicationsModuleModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationsModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationsModuleModelToJson(this);

  @override
  List<Object?> get props => [currentMedications, expiredLast90Days];
}

@JsonSerializable()
class MedicationModel extends Equatable {
  final String? startDate;
  final String? medicineName;
  final String? dosage;
  final String? selectedDoseAmount;
  final String? dosageFrequency;
  final String? timeDuration;

  const MedicationModel({
    this.startDate,
    this.medicineName,
    this.dosage,
    this.selectedDoseAmount,
    this.dosageFrequency,
    this.timeDuration,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationModelToJson(this);

  @override
  List<Object?> get props => [
        startDate,
        medicineName,
        dosage,
        selectedDoseAmount,
        dosageFrequency,
        timeDuration,
      ];
}

@JsonSerializable()
class ChronicDiseaseModel extends Equatable {
  final String? diagnosisStartDate;
  final String? diseaseName;
  final String? diseaseStatus;

  const ChronicDiseaseModel({
    this.diagnosisStartDate,
    this.diseaseName,
    this.diseaseStatus,
  });

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$ChronicDiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChronicDiseaseModelToJson(this);

  @override
  List<Object?> get props => [diagnosisStartDate, diseaseName, diseaseStatus];
}

@JsonSerializable(explicitToJson: true)
class ComplaintsModuleModel extends Equatable {
  final List<ComplaintModel>? mainComplaints;

  const ComplaintsModuleModel({this.mainComplaints});

  factory ComplaintsModuleModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintsModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintsModuleModelToJson(this);

  @override
  List<Object?> get props => [mainComplaints];
}

@JsonSerializable()
class ComplaintModel extends Equatable {
  final String? dateOfComplaintOnset;
  final String? partOfPlaceOfComplaints;
  final String? symptoms_Complaint;
  final String? natureOfComplaint;
  final String? severityOfComplaint;

  const ComplaintModel({
    this.dateOfComplaintOnset,
    this.partOfPlaceOfComplaints,
    this.symptoms_Complaint,
    this.natureOfComplaint,
    this.severityOfComplaint,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintModelToJson(this);

  @override
  List<Object?> get props => [
        dateOfComplaintOnset,
        partOfPlaceOfComplaints,
        symptoms_Complaint,
        natureOfComplaint,
        severityOfComplaint,
      ];
}

@JsonSerializable()
class PreDescriptionModel extends Equatable {
  final String? preDescriptionDate;
  final String? doctorName;
  final String? doctorSpecialty;

  const PreDescriptionModel({
    this.preDescriptionDate,
    this.doctorName,
    this.doctorSpecialty,
  });

  factory PreDescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$PreDescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreDescriptionModelToJson(this);

  @override
  List<Object?> get props => [preDescriptionDate, doctorName, doctorSpecialty];
}

@JsonSerializable(explicitToJson: true)
class MedicalTestModel extends Equatable {
  final String? testName;
  final String? code;
  final String? group;
  final List<MedicalTestResultModel>? results;

  const MedicalTestModel({this.testName, this.code, this.group, this.results});

  factory MedicalTestModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalTestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalTestModelToJson(this);

  @override
  List<Object?> get props => [testName, code, group, results];
}

@JsonSerializable()
class MedicalTestResultModel extends Equatable {
  final dynamic value;
  final String? testDate;

  const MedicalTestResultModel({this.value, this.testDate});

  factory MedicalTestResultModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalTestResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalTestResultModelToJson(this);

  @override
  List<Object?> get props => [value, testDate];
}

@JsonSerializable()
class RadiologyModel extends Equatable {
  final String? radiologyDate;
  final String? bodyPart;
  final String? radioType;
  final List<String>? periodicUsage;

  const RadiologyModel({
    this.radiologyDate,
    this.bodyPart,
    this.radioType,
    this.periodicUsage,
  });

  factory RadiologyModel.fromJson(Map<String, dynamic> json) =>
      _$RadiologyModelFromJson(json);

  Map<String, dynamic> toJson() => _$RadiologyModelToJson(this);

  @override
  List<Object?> get props =>
      [radiologyDate, bodyPart, radioType, periodicUsage];
}

@JsonSerializable()
class SurgeryEntryModel extends Equatable {
  final String? surgeryName;
  final String? surgeryDate;
  final String? surgeryRegion;
  final String? usedTechnique;
  final String? surgeryStatus;
  final String? surgeonName;
  final String? hospitalCenter;
  final String? country;

  const SurgeryEntryModel({
    this.surgeryName,
    this.surgeryDate,
    this.surgeryRegion,
    this.usedTechnique,
    this.surgeryStatus,
    this.surgeonName,
    this.hospitalCenter,
    this.country,
  });

  factory SurgeryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$SurgeryEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurgeryEntryModelToJson(this);

  @override
  List<Object?> get props => [
        surgeryName,
        surgeryDate,
        surgeryRegion,
        usedTechnique,
        surgeryStatus,
        surgeonName,
        hospitalCenter,
        country,
      ];
}

@JsonSerializable(explicitToJson: true)
class GeneticDiseasesModuleModel extends Equatable {
  final List<GeneticDiseaseModel>? myExpectedGeneticDiseases;

  const GeneticDiseasesModuleModel({this.myExpectedGeneticDiseases});

  factory GeneticDiseasesModuleModel.fromJson(Map<String, dynamic> json) =>
      _$GeneticDiseasesModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneticDiseasesModuleModelToJson(this);

  @override
  List<Object?> get props => [myExpectedGeneticDiseases];
}

@JsonSerializable()
class GeneticDiseaseModel extends Equatable {
  final String? geneticDisease;
  final String? probabilityLevel;

  const GeneticDiseaseModel({this.geneticDisease, this.probabilityLevel});

  factory GeneticDiseaseModel.fromJson(Map<String, dynamic> json) =>
      _$GeneticDiseaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneticDiseaseModelToJson(this);

  @override
  List<Object?> get props => [geneticDisease, probabilityLevel];
}

@JsonSerializable()
class AllergyModel extends Equatable {
  final String? allergyType;
  final List<String>? allergyTriggers;
  final String? symptomSeverity;
  final bool? carryEpinephrine;

  const AllergyModel({
    this.allergyType,
    this.allergyTriggers,
    this.symptomSeverity,
    this.carryEpinephrine,
  });

  factory AllergyModel.fromJson(Map<String, dynamic> json) =>
      _$AllergyModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllergyModelToJson(this);

  @override
  List<Object?> get props => [
        allergyType,
        allergyTriggers,
        symptomSeverity,
        carryEpinephrine,
      ];
}

@JsonSerializable(explicitToJson: true)
class EyeModuleModel extends Equatable {
  final List<EyeProcedureModel>? eyeProcedures;

  const EyeModuleModel({this.eyeProcedures});

  factory EyeModuleModel.fromJson(Map<String, dynamic> json) =>
      _$EyeModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeModuleModelToJson(this);

  @override
  List<Object?> get props => [eyeProcedures];
}

@JsonSerializable()
class EyeProcedureModel extends Equatable {
  final String? medicalReportDate;
  final String? affectedEyePart;
  final List<String>? symptoms;
  final List<String>? medicalProcedures;

  const EyeProcedureModel({
    this.medicalReportDate,
    this.affectedEyePart,
    this.symptoms,
    this.medicalProcedures,
  });

  factory EyeProcedureModel.fromJson(Map<String, dynamic> json) =>
      _$EyeProcedureModelFromJson(json);

  Map<String, dynamic> toJson() => _$EyeProcedureModelToJson(this);

  @override
  List<Object?> get props => [
        medicalReportDate,
        affectedEyePart,
        symptoms,
        medicalProcedures,
      ];
}

@JsonSerializable(explicitToJson: true)
class TeethModuleModel extends Equatable {
  final List<TeethProcedureModel>? teethProcedures;

  const TeethModuleModel({this.teethProcedures});

  factory TeethModuleModel.fromJson(Map<String, dynamic> json) =>
      _$TeethModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeethModuleModelToJson(this);

  @override
  List<Object?> get props => [teethProcedures];
}

@JsonSerializable()
class TeethProcedureModel extends Equatable {
  final String? procedureDate;
  final String? teethNumber;
  final String? primaryProcedure;
  final String? subProcedure;

  const TeethProcedureModel({
    this.procedureDate,
    this.teethNumber,
    this.primaryProcedure,
    this.subProcedure,
  });

  factory TeethProcedureModel.fromJson(Map<String, dynamic> json) =>
      _$TeethProcedureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeethProcedureModelToJson(this);

  @override
  List<Object?> get props => [
        procedureDate,
        teethNumber,
        primaryProcedure,
        subProcedure,
      ];
}

@JsonSerializable(explicitToJson: true)
class MentalIllnessModuleModel extends Equatable {
  final List<MentalIllnessModel>? mentalIllnesses;
  final List<BehavioralDisorderModel>? behavioralDisorders;

  const MentalIllnessModuleModel({
    this.mentalIllnesses,
    this.behavioralDisorders,
  });

  factory MentalIllnessModuleModel.fromJson(Map<String, dynamic> json) =>
      _$MentalIllnessModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentalIllnessModuleModelToJson(this);

  @override
  List<Object?> get props => [mentalIllnesses, behavioralDisorders];
}

@JsonSerializable()
class MentalIllnessModel extends Equatable {
  final String? diagnosisDate;
  final String? mentalIllnessType;
  final String? illnessSeverity;
  final String? illnessDuration;

  const MentalIllnessModel({
    this.diagnosisDate,
    this.mentalIllnessType,
    this.illnessSeverity,
    this.illnessDuration,
  });

  factory MentalIllnessModel.fromJson(Map<String, dynamic> json) =>
      _$MentalIllnessModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentalIllnessModelToJson(this);

  @override
  List<Object?> get props => [
        diagnosisDate,
        mentalIllnessType,
        illnessSeverity,
        illnessDuration,
      ];
}

@JsonSerializable()
class BehavioralDisorderModel extends Equatable {
  final String? assessmentDate;
  final String? axes;
  final String? overallLevel;

  const BehavioralDisorderModel({
    this.assessmentDate,
    this.axes,
    this.overallLevel,
  });

  factory BehavioralDisorderModel.fromJson(Map<String, dynamic> json) =>
      _$BehavioralDisorderModelFromJson(json);

  Map<String, dynamic> toJson() => _$BehavioralDisorderModelToJson(this);

  @override
  List<Object?> get props => [assessmentDate, axes, overallLevel];
}

@JsonSerializable(explicitToJson: true)
class NutritionTrackingModuleModel extends Equatable {
  final DateRangeModel? dateRange;
  final List<NutrientReportModel>? nutritionReport;

  const NutritionTrackingModuleModel({this.dateRange, this.nutritionReport});

  factory NutritionTrackingModuleModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionTrackingModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionTrackingModuleModelToJson(this);

  @override
  List<Object?> get props => [dateRange, nutritionReport];
}

@JsonSerializable()
class DateRangeModel extends Equatable {
  final String? from;
  final String? to;

  const DateRangeModel({this.from, this.to});

  factory DateRangeModel.fromJson(Map<String, dynamic> json) =>
      _$DateRangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DateRangeModelToJson(this);

  @override
  List<Object?> get props => [from, to];
}

@JsonSerializable()
class NutrientReportModel extends Equatable {
  final String? nutrient;
  final double? dailyAverageActual;
  final double? dailyAverageStandard;
  final double? actualCumulative;
  final double? standardCumulative;
  final double? difference;
  final double? percentage;

  const NutrientReportModel({
    this.nutrient,
    this.dailyAverageActual,
    this.dailyAverageStandard,
    this.actualCumulative,
    this.standardCumulative,
    this.difference,
    this.percentage,
  });

  factory NutrientReportModel.fromJson(Map<String, dynamic> json) =>
      _$NutrientReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientReportModelToJson(this);

  @override
  List<Object?> get props => [
        nutrient,
        dailyAverageActual,
        dailyAverageStandard,
        actualCumulative,
        standardCumulative,
        difference,
        percentage,
      ];
}

@JsonSerializable(explicitToJson: true)
class PhysicalActivityModuleModel extends Equatable {
  final DateRangeModel? dateRange;
  final String? planType;
  final int? totalExerciseDays;
  final int? totalExerciseMinutes;
  final double? averageMinutesPerDay;
  final double? exerciseMinutesSpent;
  final double? muscleBuildingUnitsActual;
  final double? muscleBuildingUnitsStandard;
  final double? muscleMaintenanceUnitsActual;
  final double? muscleMaintenanceUnitsStandard;

  const PhysicalActivityModuleModel({
    this.dateRange,
    this.planType,
    this.totalExerciseDays,
    this.totalExerciseMinutes,
    this.averageMinutesPerDay,
    this.exerciseMinutesSpent,
    this.muscleBuildingUnitsActual,
    this.muscleBuildingUnitsStandard,
    this.muscleMaintenanceUnitsActual,
    this.muscleMaintenanceUnitsStandard,
  });

  factory PhysicalActivityModuleModel.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalActivityModuleModelToJson(this);

  @override
  List<Object?> get props => [
        dateRange,
        planType,
        totalExerciseDays,
        totalExerciseMinutes,
        averageMinutesPerDay,
        exerciseMinutesSpent,
        muscleBuildingUnitsActual,
        muscleBuildingUnitsStandard,
        muscleMaintenanceUnitsActual,
        muscleMaintenanceUnitsStandard,
      ];
}

@JsonSerializable(explicitToJson: true)
class SupplementsModuleModel extends Equatable {
  final List<SupplementModel>? supplements;

  const SupplementsModuleModel({this.supplements});

  factory SupplementsModuleModel.fromJson(Map<String, dynamic> json) =>
      _$SupplementsModuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplementsModuleModelToJson(this);

  @override
  List<Object?> get props => [supplements];
}

@JsonSerializable()
class SupplementModel extends Equatable {
  final String? date;
  final String? supplementName;
  final String? dosage;
  final String? planType;
  final int? noOfDaysDoseTaken;

  const SupplementModel({
    this.date,
    this.supplementName,
    this.dosage,
    this.planType,
    this.noOfDaysDoseTaken,
  });

  factory SupplementModel.fromJson(Map<String, dynamic> json) =>
      _$SupplementModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplementModelToJson(this);

  @override
  List<Object?> get props => [
        date,
        supplementName,
        dosage,
        planType,
        noOfDaysDoseTaken,
      ];
}
