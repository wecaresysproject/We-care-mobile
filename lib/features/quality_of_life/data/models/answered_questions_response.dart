import 'package:json_annotation/json_annotation.dart';

part 'answered_questions_response.g.dart';

@JsonSerializable()
class AnsweredQuestionsResponse {
  final String status;
  final AnsweredQuestionsData data;

  AnsweredQuestionsResponse({
    required this.status,
    required this.data,
  });

  factory AnsweredQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnsweredQuestionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnsweredQuestionsResponseToJson(this);
}

@JsonSerializable()
class AnsweredQuestionsData {
  final List<String> columns;
  final List<AnsweredQuestionRow> rows;

  AnsweredQuestionsData({
    required this.columns,
    required this.rows,
  });

  factory AnsweredQuestionsData.fromJson(Map<String, dynamic> json) =>
      _$AnsweredQuestionsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnsweredQuestionsDataToJson(this);
}

@JsonSerializable()
class AnsweredQuestionRow {
  final String question;
  final List<String> answersOverMonths;

  AnsweredQuestionRow({
    required this.question,
    required this.answersOverMonths,
  });

  factory AnsweredQuestionRow.fromJson(Map<String, dynamic> json) =>
      _$AnsweredQuestionRowFromJson(json);

  Map<String, dynamic> toJson() => _$AnsweredQuestionRowToJson(this);
}
