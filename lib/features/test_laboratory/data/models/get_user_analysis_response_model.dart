import 'package:json_annotation/json_annotation.dart';

part 'get_user_analysis_response_model.g.dart';

@JsonSerializable()
class GetUserAnalysisReponseModel {
  bool success;
  String message;
  List<AnalysisSummarizedData> data;

  GetUserAnalysisReponseModel(
      {required this.success, required this.message, required this.data});

  factory GetUserAnalysisReponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetUserAnalysisReponseModelFromJson(json);
}

@JsonSerializable()
class AnalysisSummarizedData {
  String id;
  String testName;
  String code;
  String? standardRate;
  String testDate;
  @JsonKey(name: 'writtenPercent')
  double result;

  AnalysisSummarizedData(
      {required this.id,
      required this.testName,
      required this.code,
      required this.standardRate,
      required this.testDate,
      required this.result});

  factory AnalysisSummarizedData.fromJson(Map<String, dynamic> json) =>
      _$AnalysisSummarizedDataFromJson(json);
}
