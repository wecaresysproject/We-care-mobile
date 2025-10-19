import 'package:json_annotation/json_annotation.dart';

part 'get_all_created_plans_model.g.dart';

@JsonSerializable()
class GetAllCreatedPlansModel {
  final bool planStatus;
  final String message;
  final Plan plan;

  GetAllCreatedPlansModel({
    required this.planStatus,
    required this.message,
    required this.plan,
  });

  factory GetAllCreatedPlansModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllCreatedPlansModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCreatedPlansModelToJson(this);
}

@JsonSerializable()
class Plan {
  final List<Day> days;

  Plan({required this.days});

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  Map<String, dynamic> toJson() => _$PlanToJson(this);
}

@JsonSerializable()
class Day {
  final bool hasDocument;
  final String date;
  final String dayOfWeek;

  Day({
    required this.hasDocument,
    required this.date,
    required this.dayOfWeek,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}
