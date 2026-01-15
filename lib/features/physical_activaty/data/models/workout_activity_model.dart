import 'package:json_annotation/json_annotation.dart';

part 'workout_activity_model.g.dart';

@JsonSerializable()
class WorkoutActivity {
  final int activityId;
  final String activityTitle;
  final int durationMinutes;

  WorkoutActivity({
    required this.activityId,
    required this.activityTitle,
    required this.durationMinutes,
  });

  factory WorkoutActivity.fromJson(Map<String, dynamic> json) =>
      _$WorkoutActivityFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutActivityToJson(this);
}
