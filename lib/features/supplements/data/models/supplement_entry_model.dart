import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'supplement_entry_model.g.dart';

@JsonSerializable()
class SupplementEntry extends Equatable {
  final String? name;
  final int dosagePerDay;

  const SupplementEntry({
    this.name,
    this.dosagePerDay = 0,
  });

  factory SupplementEntry.fromJson(Map<String, dynamic> json) =>
      _$SupplementEntryFromJson(json);

  Map<String, dynamic> toJson() => _$SupplementEntryToJson(this);

  SupplementEntry copyWith({
    String? name,
    int? dosagePerDay,
  }) {
    return SupplementEntry(
      name: name ?? this.name,
      dosagePerDay: dosagePerDay ?? this.dosagePerDay,
    );
  }

  @override
  List<Object?> get props => [name, dosagePerDay];
}
