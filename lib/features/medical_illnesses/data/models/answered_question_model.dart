import 'package:json_annotation/json_annotation.dart';

part 'answered_question_model.g.dart';

@JsonSerializable()
class AnsweredQuestionModel {
  final String id;
  final String category; // المحور
  @JsonKey(name: 'Question_text')
  final String questionText; // السؤال
  final String scope; // النطاق
  @JsonKey(name: 'Answered_date')
  final String answeredDate; // التاريخ

  AnsweredQuestionModel({
    required this.id,
    required this.category,
    required this.questionText,
    required this.scope,
    required this.answeredDate,
  });

  factory AnsweredQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$AnsweredQuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnsweredQuestionModelToJson(this);
}
