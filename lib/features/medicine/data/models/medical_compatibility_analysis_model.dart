import 'package:json_annotation/json_annotation.dart';

part 'medical_compatibility_analysis_model.g.dart';

@JsonSerializable()
class CompatibilityAnalysisModel {
  final String analysisSummary;
  @JsonKey(defaultValue: [])
  final List<CompatibilityIssue> issues;

  CompatibilityAnalysisModel({
    required this.analysisSummary,
    required this.issues,
  });

  factory CompatibilityAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityAnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompatibilityAnalysisModelToJson(this);
}

@JsonSerializable()
class CompatibilityIssue {
  final String title;
  final String scientificReason;
  final String riskLevel;
  final String doctorQuestion;

  CompatibilityIssue({
    required this.title,
    required this.scientificReason,
    required this.riskLevel,
    required this.doctorQuestion,
  });

  factory CompatibilityIssue.fromJson(Map<String, dynamic> json) =>
      _$CompatibilityIssueFromJson(json);

  Map<String, dynamic> toJson() => _$CompatibilityIssueToJson(this);
}
