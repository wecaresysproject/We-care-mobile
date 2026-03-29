import 'package:equatable/equatable.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';

import '../models/quality_of_life_record.dart';

class QualityOfLifeState extends Equatable {
  final Map<int, String> answers;
  final List<QualityOfLifeRecord> records;
  final List<QualityOfLifeRecord> filteredRecords;
  final bool isSaved;
  final String? error;
  final String? selectedMonthFilter;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const QualityOfLifeState({
    this.answers = const {},
    this.records = const [],
    this.filteredRecords = const [],
    this.isSaved = false,
    this.error,
    this.selectedMonthFilter,
    this.moduleGuidanceData,
  });

  QualityOfLifeState copyWith({
    Map<int, String>? answers,
    List<QualityOfLifeRecord>? records,
    List<QualityOfLifeRecord>? filteredRecords,
    bool? isSaved,
    String? error,
    String? selectedMonthFilter,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return QualityOfLifeState(
      answers: answers ?? this.answers,
      records: records ?? this.records,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      isSaved: isSaved ?? this.isSaved,
      error: error,
      selectedMonthFilter: selectedMonthFilter ?? this.selectedMonthFilter,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [
        answers,
        records,
        filteredRecords,
        isSaved,
        error,
        selectedMonthFilter,
        moduleGuidanceData,
      ];
}
