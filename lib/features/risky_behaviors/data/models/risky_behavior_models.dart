import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'risky_behavior_models.g.dart';

@JsonSerializable()
class RiskyBehaviorPeriod extends Equatable {
  final String fromDate;
  final String? toDate; // Nullable for ongoing

  const RiskyBehaviorPeriod({
    required this.fromDate,
    this.toDate,
  });

  factory RiskyBehaviorPeriod.fromJson(Map<String, dynamic> json) =>
      _$RiskyBehaviorPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$RiskyBehaviorPeriodToJson(this);

  @override
  List<Object?> get props => [fromDate, toDate];
}

@JsonSerializable()
class RiskyBehaviorDetailsModel extends Equatable {
  final String? id;
  final String section;
  final String type;
  final String option;
  final List<RiskyBehaviorPeriod> periods;
  final bool? attachToDrugInteractionModules;

  const RiskyBehaviorDetailsModel({
    this.id,
    required this.section,
    required this.type,
    required this.option,
    required this.periods,
    this.attachToDrugInteractionModules,
  });

  factory RiskyBehaviorDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RiskyBehaviorDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RiskyBehaviorDetailsModelToJson(this);

  @override
  List<Object?> get props =>
      [id, section, type, option, periods, attachToDrugInteractionModules];
}
