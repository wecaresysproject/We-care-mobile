import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class QuestionWithDynamicAnswerListOption extends StatefulWidget {
  final String questionTitle;
  final Function(String?)? onAnswerChanged;
  final String? initialValue;
  final List<String> options; // ✅ dynamic options

  const QuestionWithDynamicAnswerListOption({
    super.key,
    required this.questionTitle,
    this.onAnswerChanged,
    this.initialValue,
    required this.options, // ✅ must be provided
  });

  @override
  State<QuestionWithDynamicAnswerListOption> createState() =>
      _QuestionWithDynamicAnswerListOption();
}

class _QuestionWithDynamicAnswerListOption
    extends State<QuestionWithDynamicAnswerListOption> {
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.initialValue;
  }

  @override
  void didUpdateWidget(
      covariant QuestionWithDynamicAnswerListOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      selectedAnswer = widget.initialValue;
    }
  }

  void _handleAnswerChange(String? value) {
    setState(() {
      selectedAnswer = value;
    });

    if (widget.onAnswerChanged != null) {
      widget.onAnswerChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Title
        Text(
          widget.questionTitle,
          style: AppTextStyles.font18blackWight500,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
        ),
        verticalSpacing(10),
        // Answer Options Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: AppColorsManager.textfieldInsideColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColorsManager.textfieldOutsideBorderColor,
              width: 1,
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFECF5FF),
                Color(0xFFFBFDFF),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.options.map((option) {
              return _buildRadioOption(
                label: option,
                value: option,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 1.4,
          child: Radio<String>(
            value: value,
            groupValue: selectedAnswer,
            activeColor: AppColorsManager.mainDarkBlue,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (String? newValue) {
              _handleAnswerChange(newValue);
            },
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppTextStyles.font10blueWeight400.copyWith(
            fontSize: 16.sp,
            color: AppColorsManager.textColor,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
