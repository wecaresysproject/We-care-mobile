import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_group_model.g.dart';

@JsonSerializable()
class TestGroupModel {
  TestGroupModel({
    required this.isSuccess,
    required this.message,
    required this.groupNames,
  });

  @JsonKey(name: "success")
  bool isSuccess;
  String message;
  @JsonKey(name: "data")
  List<String> groupNames;

  factory TestGroupModel.fromJson(Map<String, dynamic> json) =>
      _$TestGroupModelFromJson(json);
}
