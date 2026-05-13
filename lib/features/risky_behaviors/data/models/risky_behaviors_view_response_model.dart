import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';

part 'risky_behaviors_view_response_model.g.dart';

/// Represents a single type entry within a section from the submissions API.
@JsonSerializable(explicitToJson: true)
class RiskyBehaviorTypeEntry extends Equatable {
  final String id;
  final String type;
  final List<BehaviorRecord> records;
  final bool? attachToDrugInteractionModules;

  const RiskyBehaviorTypeEntry({
    required this.id,
    required this.type,
    required this.records,
    this.attachToDrugInteractionModules,
  });

  factory RiskyBehaviorTypeEntry.fromJson(Map<String, dynamic> json) =>
      _$RiskyBehaviorTypeEntryFromJson(json);

  Map<String, dynamic> toJson() => _$RiskyBehaviorTypeEntryToJson(this);

  @override
  List<Object?> get props =>
      [id, type, records, attachToDrugInteractionModules];
}

/// Represents a section (e.g., "التدخين") containing multiple type entries.
@JsonSerializable(explicitToJson: true)
class RiskyBehaviorSectionResponse extends Equatable {
  final String section;
  final List<RiskyBehaviorTypeEntry> types;

  const RiskyBehaviorSectionResponse({
    required this.section,
    required this.types,
  });

  factory RiskyBehaviorSectionResponse.fromJson(Map<String, dynamic> json) =>
      _$RiskyBehaviorSectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RiskyBehaviorSectionResponseToJson(this);

  @override
  List<Object?> get props => [section, types];
}
