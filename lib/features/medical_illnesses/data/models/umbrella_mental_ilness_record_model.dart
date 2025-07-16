import 'package:flutter/material.dart';
import 'package:we_care/features/medical_illnesses/data/models/severity_level_enum.dart';

class UmbrellaMentalIlnesssRecordModel {
  final String title;
  final Color color;
  final SeverityLevel severityLevel;
  final IconData icon;
  final int followUpCount;
  final int answeredQuestions;
  final int riskScores;
  final int cumulativeScores;

  UmbrellaMentalIlnesssRecordModel(
    this.title,
    this.severityLevel,
    this.color,
    this.icon,
    this.followUpCount,
    this.answeredQuestions,
    this.riskScores,
    this.cumulativeScores,
  );
}
