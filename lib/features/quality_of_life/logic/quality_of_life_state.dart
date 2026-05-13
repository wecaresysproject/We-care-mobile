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
  final ModuleGuidanceDataModel? moduleGuidanceData;
  final String? selectedDateFrom;
  final String? selectedDateTo;
  final String? selectedMonthFilter;
  final RequestStatus questionnaireStatus;
  final RequestStatus submitStatus;
  final List<QuestionModel> questions;

  final RequestStatus answeredQuestionsStatus;
  final RequestStatus userSubmissionDatesStatus;
  final AnsweredQuestionsData? answeredQuestionsData;
  final List<String> userSubmissionDates;
  const QualityOfLifeState({
    this.answers = const {},
    this.records = const [],
    this.filteredRecords = const [],
    this.isSaved = false,
    this.error,
    this.message,
    this.moduleGuidanceData,
    this.questionnaireStatus = RequestStatus.initial,
    this.submitStatus = RequestStatus.initial,
    this.questions = const [],
    this.answeredQuestionsStatus = RequestStatus.initial,
    this.userSubmissionDatesStatus = RequestStatus.initial,
    this.answeredQuestionsData,
    this.userSubmissionDates = const [],
    this.selectedDateFrom,
    this.selectedDateTo,
    this.selectedMonthFilter,
  });

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
    String? selectedDateFrom,
    String? selectedDateTo,
  }) {
    return QualityOfLifeState(
      answers: answers ?? this.answers,
      records: records ?? this.records,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      isSaved: isSaved ?? this.isSaved,
      error: error,
      message: message ?? this.message,
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
      selectedDateFrom: selectedDateFrom ?? this.selectedDateFrom,
      selectedDateTo: selectedDateTo ?? this.selectedDateTo,
      selectedMonthFilter: selectedMonthFilter ?? this.selectedMonthFilter,
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
        moduleGuidanceData,
        questionnaireStatus,
        submitStatus,
        questions,
        answeredQuestionsStatus,
        userSubmissionDatesStatus,
        answeredQuestionsData,
        userSubmissionDates,
        selectedDateFrom,
        selectedDateTo,
        selectedMonthFilter,
      ];
}
