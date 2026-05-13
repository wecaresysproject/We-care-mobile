import 'package:json_annotation/json_annotation.dart';

part 'quality_of_life_submit_request.g.dart';

@JsonSerializable(explicitToJson: true)
class QualityOfLifeSubmitRequest {
  final List<AnswerModel> answers;

  QualityOfLifeSubmitRequest({
    required this.answers,
  });

  factory QualityOfLifeSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$QualityOfLifeSubmitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QualityOfLifeSubmitRequestToJson(this);
}

@JsonSerializable()
class AnswerModel {
  final String questionText;
  final String answer;

  AnswerModel({
    required this.questionText,
    required this.answer,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);
}
