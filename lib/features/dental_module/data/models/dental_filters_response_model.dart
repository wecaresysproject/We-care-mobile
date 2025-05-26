import 'package:json_annotation/json_annotation.dart';

part 'dental_filters_response_model.g.dart';

@JsonSerializable()
class DentalFilterResponseModel {
  List<int>? years;
  List<String>? teethNumbers;
  List<String>? subProcedures;

  DentalFilterResponseModel({this.years, this.teethNumbers, this.subProcedures});

  factory DentalFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DentalFilterResponseModelFromJson(json);
}
