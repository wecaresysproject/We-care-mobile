import 'package:equatable/equatable.dart';

class QualityQuestion extends Equatable {
  final int id;
  final String question;
  final List<String> answers;

  const QualityQuestion({
    required this.id,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => [id, question, answers];
}
