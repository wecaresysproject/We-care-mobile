import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_umbrella_model.dart';

part 'follow_up_record_model.g.dart';

@JsonSerializable()
class FollowUpRecordModel {
  final String id;
  final String date;
  final String title;
  final RiskLevel riskLevel;

  FollowUpRecordModel({
    required this.id,
    required this.date,
    required this.title,
    required this.riskLevel,
  });

  factory FollowUpRecordModel.fromJson(Map<String, dynamic> json) =>
      _$FollowUpRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpRecordModelToJson(this);
}
