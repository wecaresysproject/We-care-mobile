import 'package:json_annotation/json_annotation.dart';

part 'medical_report_response_model.g.dart';

@JsonSerializable()
class MedicalReportResponseModel {
  @JsonKey(name: 'data')
  final MedicalReportData data;
  final String message;
  final bool success;

  MedicalReportResponseModel({
    required this.data,
    required this.message,
    required this.success,
  });

  factory MedicalReportResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportResponseModelToJson(this);
}

@JsonSerializable()
class MedicalReportData {
  @JsonKey(name: 'basicInformation')
  final List<BasicInformationData>? basicInformation;

  MedicalReportData({this.basicInformation});

  factory MedicalReportData.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportDataToJson(this);
}

@JsonSerializable()
class BasicInformationData {
  final String label;
  final dynamic value;

  BasicInformationData({
    required this.label,
    required this.value,
  });

  factory BasicInformationData.fromJson(Map<String, dynamic> json) =>
      _$BasicInformationDataFromJson(json);

  Map<String, dynamic> toJson() => _$BasicInformationDataToJson(this);
}
