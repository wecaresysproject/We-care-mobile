import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_table_model.g.dart';

@JsonSerializable()
class TestTableReponseModel {
  TestTableReponseModel({
    required this.isSuccess,
    required this.message,
    required this.testTableRowsData,
  });

  @JsonKey(name: "success")
  bool isSuccess;
  String message;
  @JsonKey(name: "data")
  List<TableRowReponseModel> testTableRowsData;

  factory TestTableReponseModel.fromJson(Map<String, dynamic> json) =>
      _$TestTableReponseModelFromJson(json);
}

@JsonSerializable()
class TableRowReponseModel {
  TableRowReponseModel({
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

  factory TableRowReponseModel.fromJson(Map<String, dynamic> json) =>
      _$TableRowReponseModelFromJson(json);
}
