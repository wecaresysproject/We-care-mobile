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

  MedicalReportSelections({this.basicInformation, this.medications});

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
  final List<String> years;

  MedicineDetailsSelection({
    required this.drugNames,
    required this.years,
  });

  factory MedicineDetailsSelection.fromJson(Map<String, dynamic> json) =>
      _$MedicineDetailsSelectionFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineDetailsSelectionToJson(this);
}
