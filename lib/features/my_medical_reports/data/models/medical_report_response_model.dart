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
  final List<VitalSignGroupModel>? vitalSigns;

  MedicalReportData({this.basicInformation, this.vitalSigns});

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

@JsonSerializable()
class VitalSignGroupModel {
  final String categoryName;

  /// List of all readings for this category
  final List<VitalReadingModel> reading;

  VitalSignGroupModel({
    required this.categoryName,
    required this.reading,
  });

  factory VitalSignGroupModel.fromJson(Map<String, dynamic> json) =>
      _$VitalSignGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignGroupModelToJson(this);
}

@JsonSerializable()
class VitalReadingModel {
  final String min;
  final String? max; //* needed in case there was pressure reading
  final String date;

  VitalReadingModel({
    required this.min,
    this.max,
    required this.date,
  });

  factory VitalReadingModel.fromJson(Map<String, dynamic> json) =>
      _$VitalReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalReadingModelToJson(this);
}
