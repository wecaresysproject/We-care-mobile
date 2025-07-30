import 'package:json_annotation/json_annotation.dart';

part 'mental_illness_umbrella_model.g.dart';

@JsonSerializable()
class MentalIllnessUmbrellaModel {
  final String id;
  final String title;
  final RiskLevel riskLevel;
  final int followUpMonths;
  final int answeredQuestionsCount;
  final int lastMonthScore;
  final int cumulativeScore;

  MentalIllnessUmbrellaModel({
    required this.id,
    required this.title,
    required this.riskLevel,
    required this.followUpMonths,
    required this.answeredQuestionsCount,
    required this.lastMonthScore,
    required this.cumulativeScore,
  });

  factory MentalIllnessUmbrellaModel.fromJson(Map<String, dynamic> json) =>
      _$MentalIllnessUmbrellaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MentalIllnessUmbrellaModelToJson(this);
}

@JsonEnum(alwaysCreate: true)
enum RiskLevel {
  /// طبيعي
  @JsonValue('NORMAL')
  normal,

  /// مراقبة
  @JsonValue('UNDER_OBSERVATION')
  underObservation,

  /// خطر جزئي
  @JsonValue('PARTIAL_RISK')
  partialRisk,

  /// خطر مؤكد
  @JsonValue('CONFIRMED_RISK')
  confirmedRisk,
}
