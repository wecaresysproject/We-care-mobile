import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';

import '../models/quality_of_life_record.dart';
import '../models/quality_question.dart';
import 'quality_of_life_state.dart';

class QualityOfLifeCubit extends Cubit<QualityOfLifeState> {
  QualityOfLifeCubit(this._appSharedRepo) : super(const QualityOfLifeState()) {
    emitModuleGuidance();
  }
  final AppSharedRepo _appSharedRepo;

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
        emit(
          state.copyWith(
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  void selectAnswer(int questionId, String answer) {
    final Map<int, String> newAnswers = Map.from(state.answers);
    newAnswers[questionId] = answer;

    emit(state.copyWith(
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

    emit(state.copyWith(
      records: updatedRecords,
      filteredRecords:
          _filterRecords(updatedRecords, state.selectedMonthFilter),
      isSaved: true,
      answers: {},
    ));
  }

  void filterByMonth(String month) {
    emit(state.copyWith(
      selectedMonthFilter: month,
      filteredRecords: _filterRecords(state.records, month),
    ));
  }

  void clearFilter() {
    emit(state.copyWith(
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
}
