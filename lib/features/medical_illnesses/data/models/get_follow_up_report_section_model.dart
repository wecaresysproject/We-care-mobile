import 'package:json_annotation/json_annotation.dart';

part 'get_follow_up_report_section_model.g.dart';

@JsonSerializable()
class GetFollowUpReportSectionModel {
  final String sectionTitle;
  final String sectionContent;

  GetFollowUpReportSectionModel({
    required this.sectionContent,
    required this.sectionTitle,
  });

  factory GetFollowUpReportSectionModel.fromJson(Map<String, dynamic> json) =>
      _$GetFollowUpReportSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetFollowUpReportSectionModelToJson(this);
}
