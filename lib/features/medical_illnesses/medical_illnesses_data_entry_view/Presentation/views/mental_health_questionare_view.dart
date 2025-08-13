// Main questionnaire page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';

class MentalHealthQuestionnaireView extends StatefulWidget {
  final List<FcmQuestionModel> questions;
  const MentalHealthQuestionnaireView({
    super.key,
    required this.questions,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: 'تقييم الحالة النفسية',
              showActionButtons: false,
              titleColor: AppColorsManager.mainDarkBlue,
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
              onPress: () => print('Send answers'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final FcmQuestionModel question;
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
            color: Colors.grey.withOpacity(0.5),
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
          verticalSpacing(20),
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
          Transform.scale(
            scale: 1.2,
            child: Radio<bool>(
              value: true, // The actual selection value for this option
              groupValue: isSelected,
              activeColor: AppColorsManager.mainDarkBlue,
              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (_) => onTap(), // Call parent onTap
            ),
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
      padding: EdgeInsets.only(bottom: 20, left: 8.w, right: 8.w, top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Color(0xffE4E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColorsManager.mainDarkBlue,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          verticalSpacing(4),
          Row(
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.font22WhiteWeight600.copyWith(
                  fontSize: 16.sp,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Navigation footer component
class NavigationFooter extends StatelessWidget {
  final VoidCallback? onPress;

  const NavigationFooter({
    super.key,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onPress,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColorsManager.mainDarkBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.arrow_back, color: Color(0xFF4A90E2)),
                  SizedBox(width: 8),
                  Text(
                    'إرسال إجاباتي',
                    style: AppTextStyles.font20blackWeight600.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  ),
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

  final bool? answer;

  const QuestionnaireItem({
    required this.text,
    this.answer,
  });
}
