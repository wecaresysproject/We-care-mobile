import 'package:json_annotation/json_annotation.dart';

part 'get_analysis_by_id_response_model.g.dart';

@JsonSerializable()
class GetAnalysisByIdResponseModel {
  bool success;
  AnalysisDetailedData data;

  GetAnalysisByIdResponseModel({required this.success, required this.data});

  factory GetAnalysisByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetAnalysisByIdResponseModelFromJson(json);
}

@JsonSerializable()
class AnalysisDetailedData {
  String id;
  String userId;
  String testDate;
  String? groupName;
  String? testNeedType;
  String? symptomsForProcedure;
  String imageBase64;
  String reportBase64;
  String hospital;
  String doctor;
  String country;

  AnalysisDetailedData(
      {required this.id,
      required this.userId,
      required this.testDate,
      required this.imageBase64,
      required this.reportBase64,
      required this.hospital,
      required this.doctor,
      required this.country,
      required this.groupName,
      this.testNeedType,
      this.symptomsForProcedure});

  factory AnalysisDetailedData.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDetailedDataFromJson(json);
}
