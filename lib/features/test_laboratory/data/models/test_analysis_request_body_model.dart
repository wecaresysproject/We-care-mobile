import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';

part 'test_analysis_request_body_model.g.dart';

@JsonSerializable()
class TestAnalysisDataEnteryRequestBodyModel {
  TestAnalysisDataEnteryRequestBodyModel({
    required this.testDate,
    required this.testTableEnteredResults,
    required this.timesTestPerformed,
    required this.symptomsForProcedure,
    required this.testImage,
    required this.reportImage,
    required this.hospital,
    required this.doctor,
    required this.country,
  });
  final String testDate;
  @JsonKey(name: "result")
  final List<TableRowReponseModel> testTableEnteredResults;
  @JsonKey(name: "testNeedType")
  final String timesTestPerformed;
  final String symptomsForProcedure;
  @JsonKey(name: "imageBase64")
  final String testImage;
  @JsonKey(name: "reportBase64")
  final String reportImage;
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
    required this.symptomsForProcedure,
    required this.testImage,
    required this.reportImage,
    required this.hospital,
    required this.doctor,
    required this.country,
  });
  final String testDate;
  @JsonKey(name: "testNeedType")
  final String timesTestPerformed;
  final String symptomsForProcedure;
  @JsonKey(name: "imageBase64")
  final String testImage;
  @JsonKey(name: "reportBase64")
  final String reportImage;
  final String hospital;
  final String doctor;
  final String country;

  Map<String, dynamic> toJson() =>
      _$EditTestAnalysisDataEnteryRequestBodyModelToJson(this);
}
