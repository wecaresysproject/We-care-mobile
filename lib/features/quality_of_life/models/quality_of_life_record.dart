import 'package:equatable/equatable.dart';

class QualityOfLifeRecord extends Equatable {
  final Map<int, String> answers;
  final String month;
  final DateTime date;

  const QualityOfLifeRecord({
    required this.answers,
    required this.month,
    required this.date,
  });

  @override
  List<Object?> get props => [answers, month, date];
}
