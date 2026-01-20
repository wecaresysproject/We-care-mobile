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

  MedicalReportSelections({this.basicInformation});

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
