import 'package:json_annotation/json_annotation.dart';

part 'monthly_examination_target_model.g.dart';

/// One month's examination-target record: the goal the doctor set for that
/// month and how many examinations were actually achieved. Used both for the
/// current month's progress ring/stats and for a past month's row in the
/// history table.
@JsonSerializable()
class MonthlyExaminationTargetModel {
  final String id;
  final String monthName;
  final int year;
  final int goalCount;
  final int achievedCount;

  MonthlyExaminationTargetModel({
    required this.id,
    required this.monthName,
    required this.year,
    required this.goalCount,
    required this.achievedCount,
  });

  /// Achievement percentage relative to [goalCount], clamped to
  /// [0, 100] and rounded to the nearest whole percent. `0` when there is
  /// no goal to avoid a division by zero.
  int get completionPercentage {
    if (goalCount <= 0) return 0;
    return ((achievedCount / goalCount) * 100).round().clamp(0, 100);
  }

  factory MonthlyExaminationTargetModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyExaminationTargetModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyExaminationTargetModelToJson(this);
}
