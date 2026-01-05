import 'package:json_annotation/json_annotation.dart';

part 'supplement_follow_up_row_model.g.dart';

@JsonSerializable()
class SupplementFollowUpRowModel {
  final String nutrient;
  final double? standard;
  final double? accumulativeStandard;
  final double? difference;
  final double? value;

  SupplementFollowUpRowModel({
    required this.nutrient,
    this.standard,
    this.accumulativeStandard,
    this.difference,
    this.value,
  });

  factory SupplementFollowUpRowModel.fromJson(Map<String, dynamic> json) =>
      _$SupplementFollowUpRowModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplementFollowUpRowModelToJson(this);
}
