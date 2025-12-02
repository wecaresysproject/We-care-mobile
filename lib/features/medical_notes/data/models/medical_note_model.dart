import 'package:equatable/equatable.dart';

class MedicalNote extends Equatable {
  final String id;
  final DateTime date;
  final String content;
  final bool isSelected;

  const MedicalNote({
    required this.id,
    required this.date,
    required this.content,
    this.isSelected = false,
  });

  factory MedicalNote.fromJson(Map<String, dynamic> json) {
    return MedicalNote(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      content: json['content'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'content': content,
      'isSelected': isSelected,
    };
  }

  MedicalNote copyWith({
    String? id,
    DateTime? date,
    String? content,
    bool? isSelected,
  }) {
    return MedicalNote(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, date, content, isSelected];
}
