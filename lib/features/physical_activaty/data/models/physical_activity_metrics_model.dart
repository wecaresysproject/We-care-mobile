import 'package:json_annotation/json_annotation.dart';

part 'physical_activity_metrics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PhysicalActivityMetricsResponse {
  final PhysicalActivityData data;

  PhysicalActivityMetricsResponse({
    required this.data,
  });

  factory PhysicalActivityMetricsResponse.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityMetricsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PhysicalActivityMetricsResponseToJson(this);
}

@JsonSerializable()
class PhysicalActivityData {
  final SportPracticeMinutes? sportPracticeMinutes;
  final List<Slide> slides;

  PhysicalActivityData({
    this.sportPracticeMinutes,
    required this.slides,
  });

  factory PhysicalActivityData.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalActivityDataToJson(this);
}

@JsonSerializable()
class SportPracticeMinutes {
  final num? todayActual;
  final num? accumulativeActual;

  SportPracticeMinutes({
    this.todayActual,
    this.accumulativeActual,
  });

  factory SportPracticeMinutes.fromJson(Map<String, dynamic> json) =>
      _$SportPracticeMinutesFromJson(json);

  Map<String, dynamic> toJson() => _$SportPracticeMinutesToJson(this);
}

@JsonSerializable()
class Slide {
  final List<Metric> metrics;

  final MuscularGoals? muscularGoalsMaintenance;

  final MuscularGoals? muscularGoalsBuilding;

  Slide({
    required this.metrics,
    this.muscularGoalsMaintenance,
    this.muscularGoalsBuilding,
  });

  factory Slide.fromJson(Map<String, dynamic> json) => _$SlideFromJson(json);

  Map<String, dynamic> toJson() => _$SlideToJson(this);
}

@JsonSerializable()
class Metric {
  final String metricName;
  final num? todayActual;
  final num? accumulativeActual;
  final num? standardTarget;

  Metric({
    required this.metricName,
    this.todayActual,
    this.accumulativeActual,
    this.standardTarget,
  });

  factory Metric.fromJson(Map<String, dynamic> json) => _$MetricFromJson(json);

  Map<String, dynamic> toJson() => _$MetricToJson(this);
}

@JsonSerializable()
class MuscularGoals {
  final double? actual;
  final double? target;

  MuscularGoals({
    this.actual,
    this.target,
  });

  factory MuscularGoals.fromJson(Map<String, dynamic> json) =>
      _$MuscularGoalsFromJson(json);

  Map<String, dynamic> toJson() => _$MuscularGoalsToJson(this);
}
