import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';

import '../data/models/quality_of_life_submit_request.dart';
import '../data/repos/quality_of_life_repo.dart';
import '../models/quality_of_life_record.dart';
import '../models/quality_of_life_table_model.dart';
import '../models/quality_question.dart';
import 'quality_of_life_state.dart';

class QualityOfLifeCubit extends Cubit<QualityOfLifeState> {
  QualityOfLifeCubit(this._appSharedRepo, this._qualityOfLifeRepo)
      : super(const QualityOfLifeState()) {
    emitModuleGuidance();
  }
  final AppSharedRepo _appSharedRepo;
  final QualityOfLifeRepo _qualityOfLifeRepo;

  static const List<String> tableColumns = [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو"
  ];

  static const List<QualityOfLifeTableRow> historyTableRows = [
    QualityOfLifeTableRow(
      question: 'كيف تقيم صحتك الجسدية العامة خلال هذا الشهر؟',
      answersForOverMonths: ['ممتازة', 'جيدة', 'مقبولة', 'جيدة', 'ممتازة'],
    ),
    QualityOfLifeTableRow(
      question: 'هل عانيت من صداع أو دوخة متكررة خلال الشهر؟',
      answersForOverMonths: ['لا', 'نعم', 'لا', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل شعرت بتعب أو إرهاق غير مبرر معظم الوقت؟',
      answersForOverMonths: ['لا', 'لا', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل عانيت من ألم في الصدر أو ضيق في التنفس خلال الشهر؟',
      answersForOverMonths: ['لا', 'لا', 'لا', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل لاحظت تغيراً ملحوظاً في وزنك هذا الشهر؟',
      answersForOverMonths: [
        'لا تغيير',
        'أخر 3 شهور',
        'زيادة ملحوظة',
        'لا تغيير',
        'لا تغيير'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'كيف تقيم حالتك النفسية العامة خلال هذا الشهر؟',
      answersForOverMonths: [
        'إيجابي جداً',
        'جيد',
        'عادي',
        'جيد',
        'إيجابي جداً'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'هل شعرت بقلق أو توتر شديد لأكثر من أسبوع متواصل؟',
      answersForOverMonths: ['لا', 'لا', 'لا', 'نعم', 'لا'],
    ),
    QualityOfLifeTableRow(
      question:
          'هل شعرت بعدم الرغبة في أي نشاط أو فقدان الاهتمام بالأشياء المعتادة؟',
      answersForOverMonths: ['لا', 'لا', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question:
          'كيف تصف مستوى تواصلك الاجتماعي مع العائلة والأصدقاء هذا الشهر؟',
      answersForOverMonths: [
        'تواصل ممتاز',
        'جيد',
        'عادي',
        'جيد',
        'تواصل ممتاز'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'كيف كان مستوى الضغط النفسي خلال الشهر؟',
      answersForOverMonths: ['لا ضغط', 'خفيف', 'متوسط', 'خفيف', 'لا ضغط'],
    ),
    QualityOfLifeTableRow(
      question: 'كيف تقيم جودة نومك خلال هذا الشهر؟',
      answersForOverMonths: ['ممتازة', 'جيدة', 'مقبولة', 'جيدة', 'ممتازة'],
    ),
    QualityOfLifeTableRow(
      question: 'كم كانت مدة نومك المعتادة يومياً؟',
      answersForOverMonths: [
        '7-9 ساعات',
        '5-7 ساعات',
        'أقل من 5',
        '7-9 ساعات',
        '7-9 ساعات'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'هل كان نومك في أوقات منتظمة معظم أيام الشهر؟',
      answersForOverMonths: ['نعم', 'أحياناً', 'لا', 'نعم', 'نعم'],
    ),
    QualityOfLifeTableRow(
      question: 'هل كنت تستيقظ منتعشاً ونشيطاً في الغالب؟',
      answersForOverMonths: ['نعم', 'أحياناً', 'لا', 'نعم', 'نعم'],
    ),
    QualityOfLifeTableRow(
      question: 'هل كنت تستيقظ أثناء الليل بشكل متكرر؟',
      answersForOverMonths: ['لا', 'أحياناً', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل عانيت من أحلام مزعجة أو كوابيس متكررة؟',
      answersForOverMonths: ['لا', 'لا', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل شعرت بحاجة قسرية للنوم أثناء النهار؟',
      answersForOverMonths: ['لا', 'لا', 'لا', 'نعم', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'كم مرة مارست نشاطاً بدنياً (30 دقيقة فأكثر) خلال الشهر؟',
      answersForOverMonths: [
        'أكثر من 10 مرات',
        '5-10 مرات',
        'لم أمارس',
        '1-4 مرات',
        'أكثر من 10 مرات'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'كيف تقيم جودة تغذيتك خلال هذا الشهر؟',
      answersForOverMonths: [
        'صحية جداً',
        'جيدة',
        'مقبولة',
        'جيدة',
        'صحية جداً'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'ما مدى التزامك بمواعيد الدواء خلال هذا الشهر؟',
      answersForOverMonths: [
        'التزمت تماماً',
        'معظم الأوقات',
        'نادراً',
        'معظم الأوقات',
        'التزمت تماماً'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'هل أوقفت أي دواء أو علاج من تلقاء نفسك خلال هذا الشهر؟',
      answersForOverMonths: ['لا', 'لا', 'لا', 'نعم', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل تعرضت لحدث ضاغط كبير خلال الشهر؟',
      answersForOverMonths: ['لا', 'لا', 'لا', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل استخدمت التدخين، الكحول، أو أي مواد أخرى خلال هذا الشهر؟',
      answersForOverMonths: ['لا', 'لا', 'نعم بشكل نادر', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question:
          'هل كانت هناك أيام تغيبت فيها أو لم تستطع فيها أداء مهامك اليومية المعتادة؟',
      answersForOverMonths: ['لا', 'لا', '1-3 أيام', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'كم كان متوسط ساعات عملك اليومية هذا الشهر؟',
      answersForOverMonths: [
        '6-9 ساعات',
        '9-12 ساعة',
        'أكثر من 12',
        '6-9 ساعات',
        '6-9 ساعات'
      ],
    ),
    QualityOfLifeTableRow(
      question: 'هل شعرت بإجهاد ذهني شديد بسبب العمل؟',
      answersForOverMonths: ['لا', 'أحياناً', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل شعرت بإجهاد جسدي شديد بسبب العمل أو النشاط اليومي؟',
      answersForOverMonths: ['لا', 'أحياناً', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل تعرضت بشكل متكرر لبيئة بها تلوث هواء أو أدخنة أو أتربة؟',
      answersForOverMonths: ['لا', 'لا', 'نعم', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل تعرضت لضوضاء شديدة أو مستمرة في العمل أو السكن؟',
      answersForOverMonths: ['لا', 'لا', 'لا', 'نعم', 'لا'],
    ),
    QualityOfLifeTableRow(
      question:
          'هل تعرضت لمواد كيميائية أو مبيدات أو مذيبات في العمل أو المنزل؟',
      answersForOverMonths: ['لا', 'نعم', 'لا', 'لا', 'لا'],
    ),
    QualityOfLifeTableRow(
      question: 'هل زرت طبيباً أو مستشفى أو مركزاً صحياً خلال هذا الشهر؟',
      answersForOverMonths: [
        'لا',
        'نعم، زيارة روتينية',
        'نعم، بسبب عارض طارئ',
        'لا',
        'لا'
      ],
    ),
  ];

  static const List<QualityQuestion> questions = [
    QualityQuestion(
      id: 1,
      question: 'كيف تقيم صحتك الجسدية العامة خلال هذا الشهر؟',
      answers: ['سيئة جداً', 'سيئة', 'مقبولة', 'جيدة', 'ممتازة'],
    ),
    QualityQuestion(
      id: 2,
      question: 'هل عانيت من صداع أو دوخة متكررة خلال الشهر؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 3,
      question: 'هل شعرت بتعب أو إرهاق غير مبرر معظم الوقت؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 4,
      question: 'هل عانيت من ألم في الصدر أو ضيق في التنفس خلال الشهر؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 5,
      question: 'هل لاحظت تغيراً ملحوظاً في وزنك هذا الشهر؟',
      answers: ['زيادة ملحوظة', 'نقصان ملحوظ', 'لا تغيير'],
    ),
    QualityQuestion(
      id: 6,
      question: 'كيف تقيم حالتك النفسية العامة خلال هذا الشهر؟',
      answers: ['كئيب جداً', 'كئيب', 'عادي', 'جيد', 'إيجابي جداً'],
    ),
    QualityQuestion(
      id: 7,
      question: 'هل شعرت بقلق أو توتر شديد لأكثر من أسبوع متواصل؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 8,
      question:
          'هل شعرت بعدم الرغبة في أي نشاط أو فقدان الاهتمام بالأشياء المعتادة؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 9,
      question:
          'كيف تصف مستوى تواصلك الاجتماعي مع العائلة والأصدقاء هذا الشهر؟',
      answers: ['انعزلت تماماً', 'ضعيف', 'عادي', 'جيد', 'تواصل ممتاز'],
    ),
    QualityQuestion(
      id: 10,
      question: 'كيف كان مستوى الضغط النفسي خلال الشهر؟',
      answers: ['لا ضغط', 'خفيف', 'متوسط', 'عالٍ', 'شديد جداً'],
    ),
    QualityQuestion(
      id: 11,
      question: 'كيف تقيم جودة نومك خلال هذا الشهر؟',
      answers: ['سيئة جداً', 'سيئة', 'مقبولة', 'جيدة', 'ممتازة'],
    ),
    QualityQuestion(
      id: 12,
      question: 'كم كانت مدة نومك المعتادة يومياً؟',
      answers: ['أقل من 5 ساعات', '5-7 ساعات', '7-9 ساعات', 'أكثر من 9 ساعات'],
    ),
    QualityQuestion(
      id: 13,
      question: 'هل كان نومك في أوقات منتظمة معظم أيام الشهر؟',
      answers: ['نعم', 'أحياناً', 'لا'],
    ),
    QualityQuestion(
      id: 14,
      question: 'هل كنت تستيقظ منتعشاً ونشيطاً في الغالب؟',
      answers: ['نعم', 'أحياناً', 'لا'],
    ),
    QualityQuestion(
      id: 15,
      question: 'هل كنت تستيقظ أثناء الليل بشكل متكرر؟',
      answers: ['نعم', 'أحياناً', 'لا'],
    ),
    QualityQuestion(
      id: 16,
      question: 'هل عانيت من أحلام مزعجة أو كوابيس متكررة؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 17,
      question: 'هل شعرت بحاجة قسرية للنوم أثناء النهار؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 19, // Numbering follows the image provided
      question: 'كم مرة مارست نشاطاً بدنياً (30 دقيقة فأكثر) خلال الشهر؟',
      answers: ['لم أمارس', '1-4 مرات', '5-10 مرات', 'أكثر من 10 مرات'],
    ),
    QualityQuestion(
      id: 20,
      question: 'كيف تقيم جودة تغذيتك خلال هذا الشهر؟',
      answers: ['سيئة جداً', 'سيئة', 'مقبولة', 'جيدة', 'صحية جداً'],
    ),
    QualityQuestion(
      id: 21,
      question: 'ما مدى التزامك بمواعيد الدواء خلال هذا الشهر؟',
      answers: [
        'لا أتعاطى دواء',
        'لم ألتزم أبداً',
        'نادراً',
        'أحياناً',
        'معظم الأوقات',
        'التزمت تماماً'
      ],
    ),
    QualityQuestion(
      id: 22,
      question: 'هل أوقفت أي دواء أو علاج من تلقاء نفسك خلال هذا الشهر؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 23,
      question: 'هل تعرضت لحدث ضاغط كبير خلال الشهر؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 24,
      question: 'هل استخدمت التدخين، الكحول، أو أي مواد أخرى خلال هذا الشهر؟',
      answers: ['لا', 'نعم بشكل نادر', 'نعم بشكل متكرر'],
    ),
    QualityQuestion(
      id: 25,
      question:
          'هل كانت هناك أيام تغيبت فيها أو لم تستطع فيها أداء مهامك اليومية المعتادة (عمل، منزل، تنقل)؟',
      answers: ['لا', '1-3 أيام', 'أكثر من 3 أيام'],
    ),
    QualityQuestion(
      id: 26,
      question: 'كم كان متوسط ساعات عملك اليومية هذا الشهر؟',
      answers: ['أقل من 6', '6-9 ساعات', '9-12 ساعة', 'أكثر من 12'],
    ),
    QualityQuestion(
      id: 27,
      question: 'هل شعرت بإجهاد ذهني شديد بسبب العمل؟',
      answers: ['نعم', 'أحياناً', 'لا'],
    ),
    QualityQuestion(
      id: 28,
      question: 'هل شعرت بإجهاد جسدي شديد بسبب العمل أو النشاط اليومي؟',
      answers: ['نعم', 'أحياناً', 'لا'],
    ),
    QualityQuestion(
      id: 29,
      question: 'هل تعرضت بشكل متكرر لبيئة بها تلوث هواء أو أدخنة أو أتربة؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 30,
      question: 'هل تعرضت لضوضاء شديدة أو مستمرة في العمل أو السكن؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 31,
      question:
          'هل تعرضت لمواد كيميائية أو مبيدات أو مذيبات في العمل أو المنزل؟',
      answers: ['نعم', 'لا'],
    ),
    QualityQuestion(
      id: 32,
      question: 'هل زرت طبيباً أو مستشفى أو مركزاً صحياً خلال هذا الشهر؟',
      answers: ['لا', 'نعم، زيارة روتينية', 'نعم، بسبب عارض طارئ'],
    ),
  ];

  Future<void> emitModuleGuidance() async {
    final result = await _appSharedRepo.getModuleGuidance(
      WeCareMedicalModules.qualityOfLife.name,
    );
    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        safeEmit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  Future<void> fetchQuestionnaire() async {
    safeEmit(state.copyWith(questionnaireStatus: RequestStatus.loading));
    final result = await _qualityOfLifeRepo.fetchQuestionnaire();
    result.when(
      success: (data) {
        safeEmit(state.copyWith(
          questionnaireStatus: RequestStatus.success,
          questions: data.data,
        ));
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            questionnaireStatus: RequestStatus.failure,
            error: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> submitAssessment() async {
    if (state.answers.isEmpty) return;

    safeEmit(state.copyWith(submitStatus: RequestStatus.loading));

    final List<AnswerModel> answersList = state.answers.entries.map((entry) {
      final question =
          state.questions.firstWhere((q) => q.questionId == entry.key);
      return AnswerModel(
        questionText: question.questionText,
        answer: entry.value,
      );
    }).toList();

    final requestBody = QualityOfLifeSubmitRequest(answers: answersList);

    final result = await _qualityOfLifeRepo.submitAssessment(requestBody);

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            submitStatus: RequestStatus.success,
            isSaved: true,
            answers: {},
          ),
        );
        // You might want to update local records here if needed
      },
      failure: (error) {
        safeEmit(state.copyWith(
          submitStatus: RequestStatus.failure,
          error: error.errors.first,
        ));
      },
    );
  }

  void selectAnswer(int questionId, String answer) {
    final Map<int, String> newAnswers = Map.from(state.answers);
    newAnswers[questionId] = answer;

    safeEmit(state.copyWith(
      answers: newAnswers,
      isSaved: false,
    ));
  }

  void saveAnswers() {
    final String currentMonth = _getCurrentMonthTranslation();
    final newRecord = QualityOfLifeRecord(
      answers: Map.from(state.answers),
      month: currentMonth,
      date: DateTime.now(),
    );

    final List<QualityOfLifeRecord> updatedRecords = List.from(state.records)
      ..add(newRecord);

    safeEmit(state.copyWith(
      records: updatedRecords,
      filteredRecords:
          _filterRecords(updatedRecords, state.selectedMonthFilter),
      isSaved: true,
      answers: {},
    ));
  }

  void filterByMonth(String month) {
    safeEmit(state.copyWith(
      selectedMonthFilter: month,
      filteredRecords: _filterRecords(state.records, month),
    ));
  }

  void clearFilter() {
    safeEmit(state.copyWith(
      selectedMonthFilter: null,
      filteredRecords: state.records,
    ));
  }

  List<QualityOfLifeRecord> _filterRecords(
      List<QualityOfLifeRecord> records, String? month) {
    if (month == null || month.isEmpty) return records;
    return records.where((record) => record.month == month).toList();
  }

  String _getCurrentMonthTranslation() {
    final now = DateTime.now();
    final months = [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];
    return months[now.month - 1];
  }

  void safeEmit(QualityOfLifeState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> fetchAnsweredQuestions({String? dateRange}) async {
    safeEmit(state.copyWith(
      answeredQuestionsStatus: RequestStatus.loading,
      selectedDateRange: dateRange,
    ));
    final result = await _qualityOfLifeRepo.fetchAnsweredQuestions(dateRange);
    result.when(
      success: (data) {
        safeEmit(state.copyWith(
          answeredQuestionsStatus: RequestStatus.success,
          answeredQuestionsData: data.data,
        ));
      },
      failure: (error) {
        safeEmit(state.copyWith(
          answeredQuestionsStatus: RequestStatus.failure,
          error: error.errors.first,
        ));
      },
    );
  }

  Future<void> fetchDateRanges() async {
    safeEmit(state.copyWith(dateRangesStatus: RequestStatus.loading));
    final result = await _qualityOfLifeRepo.fetchDateRanges();
    result.when(
      success: (dateRanges) {
        safeEmit(
          state.copyWith(
            dateRangesStatus: RequestStatus.success,
            dateRanges: dateRanges,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            dateRangesStatus: RequestStatus.failure,
            error: error.errors.first,
          ),
        );
      },
    );
  }
}
