import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';

import '../data/models/answered_questions_response.dart';
import '../data/models/quality_of_life_questionnaire_response.dart';
import '../models/quality_of_life_record.dart';

class QualityOfLifeState extends Equatable {
  final Map<int, String> answers;
  final List<QualityOfLifeRecord> records;
  final List<QualityOfLifeRecord> filteredRecords;
  final bool isSaved;
  final String? error;
  final String? message;
  final String? selectedMonthFilter;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const QualityOfLifeState({
    this.answers = const {},
    this.records = const [],
    this.filteredRecords = const [],
    this.isSaved = false,
    this.error,
    this.message,
    this.selectedMonthFilter,
    this.moduleGuidanceData,
    this.questionnaireStatus = RequestStatus.initial,
    this.submitStatus = RequestStatus.initial,
    this.questions = const [],
    this.answeredQuestionsStatus = RequestStatus.initial,
    this.userSubmissionDatesStatus = RequestStatus.initial,
    this.answeredQuestionsData,
    this.userSubmissionDates = const [],
    this.selectedDateRange,
  });

  final RequestStatus questionnaireStatus;
  final RequestStatus submitStatus;
  final List<QuestionModel> questions;

  final RequestStatus answeredQuestionsStatus;
  final RequestStatus userSubmissionDatesStatus;
  final AnsweredQuestionsData? answeredQuestionsData;
  final List<String> userSubmissionDates;
  final String? selectedDateRange;

  QualityOfLifeState copyWith({
    Map<int, String>? answers,
    List<QualityOfLifeRecord>? records,
    List<QualityOfLifeRecord>? filteredRecords,
    bool? isSaved,
    String? error,
    String? message,
    String? selectedMonthFilter,
    ModuleGuidanceDataModel? moduleGuidanceData,
    RequestStatus? questionnaireStatus,
    RequestStatus? submitStatus,
    List<QuestionModel>? questions,
    RequestStatus? answeredQuestionsStatus,
    RequestStatus? userSubmissionDatesStatus,
    AnsweredQuestionsData? answeredQuestionsData,
    List<String>? userSubmissionDates,
    String? selectedDateRange,
  }) {
    return QualityOfLifeState(
      answers: answers ?? this.answers,
      records: records ?? this.records,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      isSaved: isSaved ?? this.isSaved,
      error: error,
      message: message ?? this.message,
      selectedMonthFilter: selectedMonthFilter ?? this.selectedMonthFilter,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
      questionnaireStatus: questionnaireStatus ?? this.questionnaireStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      questions: questions ?? this.questions,
      answeredQuestionsStatus:
          answeredQuestionsStatus ?? this.answeredQuestionsStatus,
      userSubmissionDatesStatus:
          userSubmissionDatesStatus ?? this.userSubmissionDatesStatus,
      answeredQuestionsData:
          answeredQuestionsData ?? this.answeredQuestionsData,
      userSubmissionDates: userSubmissionDates ?? this.userSubmissionDates,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
    );
  }

  @override
  List<Object?> get props => [
        answers,
        records,
        filteredRecords,
        isSaved,
        error,
        message,
        selectedMonthFilter,
        moduleGuidanceData,
        questionnaireStatus,
        submitStatus,
        questions,
        answeredQuestionsStatus,
        userSubmissionDatesStatus,
        answeredQuestionsData,
        userSubmissionDates,
        selectedDateRange,
      ];
}
