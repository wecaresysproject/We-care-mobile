import 'package:json_annotation/json_annotation.dart';

part 'physical_activity_day_model.g.dart';

@JsonSerializable()
class PhysicalActivityDayModel {
  final String date;
  final String day;
  final int exerciseMinutes;
  final int consumedCalories;
  final int burnedCalories;
  final int muscleBuildingUnits;
  final int muscleMaintenanceUnits;
  final double muscleBuildingPercentage;
  final double muscleMaintenancePercentage;
  final int muscleBuildingAccumulated;
  final int muscleMaintenanceAccumulated;
  final int currentWeight;
  final double targetWeightMin;
  final double targetWeightMax;

  PhysicalActivityDayModel({
    required this.date,
    required this.day,
    required this.exerciseMinutes,
    required this.consumedCalories,
    required this.burnedCalories,
    required this.muscleBuildingUnits,
    required this.muscleMaintenanceUnits,
    required this.muscleBuildingPercentage,
    required this.muscleMaintenancePercentage,
    required this.muscleBuildingAccumulated,
    required this.muscleMaintenanceAccumulated,
    required this.currentWeight,
    required this.targetWeightMin,
    required this.targetWeightMax,
  });

  factory PhysicalActivityDayModel.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhysicalActivityDayModelToJson(this);
}

class PhysicalActivityTotals {
  final int exerciseMinutes;
  final int consumedCalories;
  final int burnedCalories;
  final int muscleBuildingUnits;
  final int muscleMaintenanceUnits;
  final int currentWeight;
  final double targetWeightMax;
  final double targetWeightMin;

  PhysicalActivityTotals({
    required this.exerciseMinutes,
    required this.consumedCalories,
    required this.burnedCalories,
    required this.muscleBuildingUnits,
    required this.muscleMaintenanceUnits,
    required this.currentWeight,
    required this.targetWeightMax,
    required this.targetWeightMin,
  });
}
