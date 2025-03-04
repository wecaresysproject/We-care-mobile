import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_name_model.g.dart';

@JsonSerializable()
class TestNameModel {
  TestNameModel({
    required this.isSuccess,
    required this.message,
    required this.testNames,
  });

  @JsonKey(name: "success")
  bool isSuccess;
  String message;
  @JsonKey(name: "data")
  List<String> testNames;

  factory TestNameModel.fromJson(Map<String, dynamic> json) =>
      _$TestNameModelFromJson(json);
}
