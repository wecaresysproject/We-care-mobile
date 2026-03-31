import 'package:json_annotation/json_annotation.dart';

part 'quality_of_life_questionnaire_response.g.dart';

@JsonSerializable()
class QualityOfLifeQuestionnaireResponse {
  final String status;
  final List<QuestionModel> data;

  QualityOfLifeQuestionnaireResponse({
    required this.status,
    required this.data,
  });

  factory QualityOfLifeQuestionnaireResponse.fromJson(Map<String, dynamic> json) =>
      _$QualityOfLifeQuestionnaireResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QualityOfLifeQuestionnaireResponseToJson(this);
}

@JsonSerializable()
class QuestionModel {
  final int questionId;
  final String questionText;
  final List<OptionModel> options;

  QuestionModel({
    required this.questionId,
    required this.questionText,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

@JsonSerializable()
class OptionModel {
  final int optionId;
  final String optionText;

  OptionModel({
    required this.optionId,
    required this.optionText,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);
}
