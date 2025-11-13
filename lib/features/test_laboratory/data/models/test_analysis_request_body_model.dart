import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';

part 'test_analysis_request_body_model.g.dart';

@JsonSerializable()
class TestAnalysisDataEnteryRequestBodyModel {
  TestAnalysisDataEnteryRequestBodyModel({
    required this.testDate,
    required this.testTableEnteredResults,
    required this.timesTestPerformed,
    required this.symptomsRequiringIntervention,
    required this.testImages,
    required this.reportImages,
    required this.hospital,
    required this.doctor,
    required this.country,
    required this.writtenReport,
  });
  final String testDate;
  @JsonKey(name: "result")
  final List<TableRowReponseModel> testTableEnteredResults;
  @JsonKey(name: "testNeedType")
  final String timesTestPerformed;
  @JsonKey(name: "symptomsForProcedure")
  final String symptomsRequiringIntervention;
  @JsonKey(name: "imageBase64")
  final List<String> testImages;
  @JsonKey(name: "reportBase64")
  final List<String> reportImages;
  final String writtenReport;
  final String hospital;
  final String doctor;
  final String country;

  Map<String, dynamic> toJson() =>
      _$TestAnalysisDataEnteryRequestBodyModelToJson(this);
}

@JsonSerializable()
class EditTestAnalysisDataEnteryRequestBodyModel {
  EditTestAnalysisDataEnteryRequestBodyModel({
    required this.testDate,
    required this.timesTestPerformed,
    required this.symptomsRequiringIntervention,
    required this.testImages,
    required this.reportImages,
    required this.hospital,
    required this.doctor,
    required this.country,
  });
  final String testDate;
  @JsonKey(name: "testNeedType")
  final String timesTestPerformed;
  @JsonKey(name: "symptomsForProcedure")
  final String symptomsRequiringIntervention;
  @JsonKey(name: "imageBase64")
  final List<String> testImages;
  @JsonKey(name: "reportBase64")
  final List<String> reportImages;
  final String hospital;
  final String doctor;
  final String country;

  Map<String, dynamic> toJson() =>
      _$EditTestAnalysisDataEnteryRequestBodyModelToJson(this);
}
