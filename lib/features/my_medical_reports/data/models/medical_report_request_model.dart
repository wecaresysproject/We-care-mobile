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

  @JsonKey(name: 'urgentComplaints')
  final UrgentComplaintsSelectionRequestBody? urgentComplaints;

  @JsonKey(name: 'radiology')
  final RadiologySelectionRequestBody? radiology;

  @JsonKey(name: 'vitalSigns')
  final VitalSignsSelectionRequestBody? vitalSigns;

  @JsonKey(name: 'medicalTests')
  final MedicalTestsSelectionRequestBody? medicalTests;

  @JsonKey(name: 'prescriptions')
  final PrescriptionsSelectionRequestBody? prescriptions;

  MedicalReportSelections({
    this.basicInformation,
    this.medications,
    this.chronicDiseases,
    this.urgentComplaints,
    this.radiology,
    this.vitalSigns,
    this.medicalTests,
    this.prescriptions,
  });

  factory MedicalReportSelections.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportSelectionsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportSelectionsToJson(this);
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
  final List<String> years;
  final List<String> organs;
  final List<String> complaints;

  UrgentComplaintsSelectionRequestBody({
    required this.getAll,
    required this.years,
    required this.organs,
    required this.complaints,
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
  final List<String> regions;
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
  final bool attachImages;
  final List<String> years;
  final List<String> testGroups;

  MedicalTestsSelectionRequestBody({
    required this.getAll,
    required this.attachImages,
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
  final bool attachImages;
  final List<String> years;
  final List<String> specialties;
  final List<String> doctorNames;

  PrescriptionsSelectionRequestBody({
    required this.getAll,
    required this.attachImages,
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
