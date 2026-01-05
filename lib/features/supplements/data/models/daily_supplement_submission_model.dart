import 'package:json_annotation/json_annotation.dart';

part 'daily_supplement_submission_model.g.dart';

@JsonSerializable()
class DailySupplementSubmissionModel {
  final String date;
  final bool hasDocument;
  final List<String> vitaminsTaken;

  DailySupplementSubmissionModel({
    required this.date,
    required this.hasDocument,
    required this.vitaminsTaken,
  });

  factory DailySupplementSubmissionModel.fromJson(Map<String, dynamic> json) =>
      _$DailySupplementSubmissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailySupplementSubmissionModelToJson(this);
}
