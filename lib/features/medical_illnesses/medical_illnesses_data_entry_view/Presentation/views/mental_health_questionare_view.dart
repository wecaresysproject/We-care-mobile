// Main questionnaire page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MentalHealthQuestionnaireView extends StatefulWidget {
  final List<QuestionnaireItem> questions;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Function(Map<int, bool>)? onAnswersChanged;

  const MentalHealthQuestionnaireView({
    super.key,
    required this.questions,
    this.onNext,
    this.onPrevious,
    this.onAnswersChanged,
  });

  @override
  State<MentalHealthQuestionnaireView> createState() =>
      _MentalHealthQuestionnairePageState();
}

class _MentalHealthQuestionnairePageState
    extends State<MentalHealthQuestionnaireView> {
  Map<int, bool> answers = {};
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  void _updateProgress() {
    if (widget.questions.isNotEmpty) {
      progress = answers.length / widget.questions.length;
    }
  }

  void _onAnswerChanged(int questionIndex, bool answer) {
    setState(() {
      answers[questionIndex] = answer;
      _updateProgress();
    });
    widget.onAnswersChanged?.call(answers);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Column(
          children: [
            CustomAppBarWidget(
              haveBackArrow: true,
            ),
            // Progress Header
            ProgressHeader(
              progress: progress,
            ),

            // Questions List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: QuestionCard(
                      question: widget.questions[index],
                      selectedAnswer: answers[index],
                      onAnswerChanged: (answer) =>
                          _onAnswerChanged(index, answer),
                    ),
                  );
                },
              ),
            ),

            // Navigation Footer
            NavigationFooter(
              onNext: widget.onNext,
              onPrevious: widget.onPrevious,
              canProceed: answers.length == widget.questions.length,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final QuestionnaireItem question;
  final bool? selectedAnswer;
  final Function(bool) onAnswerChanged;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.backGroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColorsManager.mainDarkBlue,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AnswerOption(
                  text: 'لا',
                  isSelected: selectedAnswer == false,
                  onTap: () => onAnswerChanged(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnswerOption(
                  text: 'نعم',
                  isSelected: selectedAnswer == true,
                  onTap: () => onAnswerChanged(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColorsManager.mainDarkBlue
                    : AppColorsManager.placeHolderColor,
                width: 2,
              ),
              color: isSelected
                  ? AppColorsManager.mainDarkBlue
                  : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.white,
                  )
                : null,
          ),
          horizontalSpacing(8),
          Text(
            text,
            style: AppTextStyles.font18blackWight500.copyWith(
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// Progress header component
class ProgressHeader extends StatelessWidget {
  final double progress;

  const ProgressHeader({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          ),
        ],
      ),
    );
  }
}

// Navigation footer component
class NavigationFooter extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool canProceed;

  const NavigationFooter({
    super.key,
    this.onNext,
    this.onPrevious,
    required this.canProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (onPrevious != null)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFF4A90E2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: Color(0xFF4A90E2)),
                    SizedBox(width: 8),
                    Text(
                      'السابق',
                      style: TextStyle(
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (onPrevious != null && onNext != null) const SizedBox(width: 16),
          if (onNext != null)
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'التالي',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Data model for questionnaire items
class QuestionnaireItem {
  final String text;
  final bool? yesText;
  final bool? noText;

  const QuestionnaireItem({
    required this.text,
    this.yesText,
    this.noText,
  });
}

// Example usage
class ExampleUsage extends StatefulWidget {
  const ExampleUsage({super.key});

  @override
  _ExampleUsageState createState() => _ExampleUsageState();
}

class _ExampleUsageState extends State<ExampleUsage> {
  final List<QuestionnaireItem> questions = [
    const QuestionnaireItem(
      text: 'هل تشعر أنك لا تستطيع أن تكون أكثر إنتاجية؟',
    ),
    const QuestionnaireItem(
      text: 'هل تشعر بأنك عبء على من حولك دون فائدة حقيقية؟',
    ),
    const QuestionnaireItem(
      text: 'هل تشعر أحياناً بأن لا شيء سيتغير مهما حاولت؟',
    ),
    const QuestionnaireItem(
      text: 'هل تفكر لديك أفكار بأنك شخص فاشل أو غير جدير بالحياة؟',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MentalHealthQuestionnaireView(
      questions: questions,
      onNext: () {
        print('Next button pressed');
      },
      onPrevious: () {
        print('Previous button pressed');
      },
      onAnswersChanged: (answers) {
        print('Answers changed: $answers');
      },
    );
  }
}
