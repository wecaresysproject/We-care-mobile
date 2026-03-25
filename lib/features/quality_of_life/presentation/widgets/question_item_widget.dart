import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class QuestionItemWidget extends StatelessWidget {
  final String question;
  final int id;
  final List<String> answers;
  final String? selectedAnswer;
  final Function(int id, String answer) onAnswerSelected;

  const QuestionItemWidget({
    super.key,
    required this.question,
    required this.id,
    required this.answers,
    this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.textfieldInsideColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.font16BlackSemiBold,
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: answers.map(
              (answer) {
                final bool isSelected = selectedAnswer == answer;
                return InkWell(
                  onTap: () => onAnswerSelected(id, answer),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColorsManager.mainDarkBlue
                          : AppColorsManager.textfieldInsideColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      answer,
                      style: AppTextStyles.font14BlackMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
