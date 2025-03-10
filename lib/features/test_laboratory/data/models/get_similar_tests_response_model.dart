import 'package:json_annotation/json_annotation.dart';

part 'get_similar_tests_response_model.g.dart';

@JsonSerializable()
class GetSimilarTestsResponseModel {
  bool success;
  String message;
  TestData data;

  GetSimilarTestsResponseModel(
      {required this.success, required this.message, required this.data});

  factory GetSimilarTestsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetSimilarTestsResponseModelFromJson(json);
}

@JsonSerializable()
class TestData {
  TestDetails testDetails;
  @JsonKey(name: 'summary')
  List<SimilarTests> similarTests;

  TestData({required this.testDetails, required this.similarTests});

  factory TestData.fromJson(Map<String, dynamic> json) =>
      _$TestDataFromJson(json);
}

@JsonSerializable()
class TestDetails {
  String nameTest;
  String code;
  String description;

  TestDetails(
      {required this.nameTest, required this.code, required this.description});

  factory TestDetails.fromJson(Map<String, dynamic> json) =>
      _$TestDetailsFromJson(json);
}

@JsonSerializable()
class SimilarTests {
  String id;
  String testDate;
  String testName;
  String code;
  String standardRate;
  int writtenPercent;
  String interpretation;
  @JsonKey(name: 'result')
  String recommendation;

  SimilarTests({
    required this.id,
    required this.testDate,
    required this.testName,
    required this.code,
    required this.standardRate,
    required this.writtenPercent,
    required this.interpretation,
    required this.recommendation,
  });

  factory SimilarTests.fromJson(Map<String, dynamic> json) =>
      _$SimilarTestsFromJson(json);
}
