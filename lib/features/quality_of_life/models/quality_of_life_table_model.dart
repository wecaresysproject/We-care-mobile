import 'package:equatable/equatable.dart';

class QualityOfLifeTableData extends Equatable {
  final List<String> columns;
  final List<QualityOfLifeTableRow> rows;

  const QualityOfLifeTableData({
    required this.columns,
    required this.rows,
  });

  @override
  List<Object?> get props => [columns, rows];
}

class QualityOfLifeTableRow extends Equatable {
  final String question;
  final List<String> answersForOverMonths;

  const QualityOfLifeTableRow({
    required this.question,
    required this.answersForOverMonths,
  });

  @override
  List<Object?> get props => [question, answersForOverMonths];
}
