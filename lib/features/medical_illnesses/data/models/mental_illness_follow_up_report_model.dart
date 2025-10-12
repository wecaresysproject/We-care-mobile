import 'package:json_annotation/json_annotation.dart';

part 'mental_illness_follow_up_report_model.g.dart';

@JsonSerializable()
class MentalIllnessFollowUpReportModel {
  final String title;
  final String date;
  final String riskLevel;
  final String id;

  MentalIllnessFollowUpReportModel({
    required this.title,
    required this.date,
    required this.riskLevel,
    required this.id,
  });

  factory MentalIllnessFollowUpReportModel.fromJson(
          Map<String, dynamic> json) =>
      _$MentalIllnessFollowUpReportModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MentalIllnessFollowUpReportModelToJson(this);
}
