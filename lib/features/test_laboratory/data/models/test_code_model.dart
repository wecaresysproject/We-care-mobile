import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_code_model.g.dart';

@JsonSerializable()
class TestCodeModel {
  TestCodeModel({
    required this.isSuccess,
    required this.message,
    required this.codesData,
  });

  @JsonKey(name: "success")
  bool isSuccess;
  String message;
  @JsonKey(name: "data")
  List<String> codesData;

  factory TestCodeModel.fromJson(Map<String, dynamic> json) =>
      _$TestCodeModelFromJson(json);
}
