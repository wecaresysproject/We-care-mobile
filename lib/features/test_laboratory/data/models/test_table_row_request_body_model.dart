import 'package:json_annotation/json_annotation.dart';

part 'test_table_row_request_body_model.g.dart';

@JsonSerializable()
class TableRoWRequestBodyModel {
  TableRoWRequestBodyModel({
    required this.testName,
    required this.testCode,
    required this.groupName,
    required this.standardRate,
    required this.testWrittenPercent,
  });

  String testName;
  @JsonKey(name: "code")
  String testCode;
  String groupName;
  String standardRate;
  @JsonKey(name: "writtenPercent")
  double testWrittenPercent;

  Map<String, dynamic> toJson() => _$TableRoWRequestBodyModelToJson(this);
}
