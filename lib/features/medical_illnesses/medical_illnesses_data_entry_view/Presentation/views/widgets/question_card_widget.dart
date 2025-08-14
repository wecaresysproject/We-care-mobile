import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';

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
