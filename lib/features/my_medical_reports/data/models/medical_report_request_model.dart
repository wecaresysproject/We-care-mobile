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

  MedicalReportSelections({
    this.basicInformation,
    this.medications,
    this.chronicDiseases,
    this.urgentComplaints,
  });

  factory MedicalReportSelections.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportSelectionsFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportSelectionsToJson(this);
}

@JsonSerializable()
class BasicInformationSelection {
  final bool getAll;
  final List<String> selectedValues;

  BasicInformationSelection({
    required this.getAll,
    required this.selectedValues,
  });

  factory BasicInformationSelection.fromJson(Map<String, dynamic> json) =>
      _$BasicInformationSelectionFromJson(json);

  Map<String, dynamic> toJson() => _$BasicInformationSelectionToJson(this);
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
