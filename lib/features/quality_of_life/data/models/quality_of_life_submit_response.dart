import 'package:json_annotation/json_annotation.dart';

part 'quality_of_life_submit_response.g.dart';

@JsonSerializable()
class QualityOfLifeSubmitResponse {
  final String status;
  final String message;
  final SubmitDataModel data;

  QualityOfLifeSubmitResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory QualityOfLifeSubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$QualityOfLifeSubmitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QualityOfLifeSubmitResponseToJson(this);
}

@JsonSerializable()
class SubmitDataModel {
  final String referenceId;
  final String submittedAt;

  SubmitDataModel({
    required this.referenceId,
    required this.submittedAt,
  });

  factory SubmitDataModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitDataModelToJson(this);
}
