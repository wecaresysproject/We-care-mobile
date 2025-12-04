import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medical_note_model.g.dart';

@JsonSerializable()
class MedicalNote extends Equatable {
  final String id;
  @JsonKey(name: "createdAt")
  final DateTime date;
  final String note;
  final bool? isSelected;

  const MedicalNote({
    required this.id,
    required this.date,
    required this.note,
    this.isSelected = false,
  });

  factory MedicalNote.fromJson(Map<String, dynamic> json) =>
      _$MedicalNoteFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalNoteToJson(this);

  MedicalNote copyWith({
    String? id,
    DateTime? date,
    String? note,
    bool? isSelected,
  }) {
    return MedicalNote(
      id: id ?? this.id,
      date: date ?? this.date,
      note: note ?? this.note,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, date, note, isSelected];
}
