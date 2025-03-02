import 'package:json_annotation/json_annotation.dart';

part 'xray_filters_response_model.g.dart';

@JsonSerializable()
class XRayFilterResponseModel {
  List<int>? years;
  List<String>? bodyParts;
  List<String>? radioTypes;

  XRayFilterResponseModel({this.years, this.bodyParts, this.radioTypes});

  factory XRayFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$XRayFilterResponseModelFromJson(json);
}
