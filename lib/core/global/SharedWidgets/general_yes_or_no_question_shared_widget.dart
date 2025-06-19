import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class GenericQuestionWidget extends StatefulWidget {
  final String questionTitle;
  final Function(bool?)? onAnswerChanged;
  final bool? initialValue;

  const GenericQuestionWidget({
    super.key,
    required this.questionTitle,
    this.onAnswerChanged,
    this.initialValue,
  });

  @override
  State<GenericQuestionWidget> createState() => _GenericQuestionWidgetState();
}

class _GenericQuestionWidgetState extends State<GenericQuestionWidget> {
  String? selectedAnswer; // Changed to String to work with Radio<String>

  @override
  void initState() {
    super.initState();
    // Convert bool to String for radio button compatibility
    if (widget.initialValue == true) {
      selectedAnswer = 'نعم';
    } else if (widget.initialValue == false) {
      selectedAnswer = 'لا';
    } else {
      selectedAnswer = null;
    }
  }

  void _handleAnswerChange(String? value) {
    setState(() {
      selectedAnswer = value;
    });

    // Convert String back to bool for the callback
    bool? boolValue;
    if (value == 'نعم') {
      boolValue = true;
    } else if (value == 'لا') {
      boolValue = false;
    } else {
      boolValue = null;
    }

    if (widget.onAnswerChanged != null) {
      widget.onAnswerChanged!(boolValue);
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
                color: AppColorsManager.textfieldOutsideBorderColor, width: 1),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFECF5FF), // Light blue-white
                Color(0xFFFBFDFF), // Very light blue-white
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Yes Option (Right side)
              _buildRadioOption(
                label: "نعم",
                value: "نعم",
              ),
              // No Option (Left side)
              _buildRadioOption(
                label: "لا",
                value: "لا",
              ),
            ],
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
      spacing: 8.0.w,
      children: [
        Transform.scale(
          scale: 1.4,
          child: Radio<String>(
            value: value,
            groupValue:
                selectedAnswer, // Fixed: use selectedAnswer instead of value
            activeColor:
                AppColorsManager.mainDarkBlue, // mainDarkBlue equivalent
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (String? newValue) {
              _handleAnswerChange(
                  newValue); // Fixed: pass the new value directly
            },
          ),
        ),
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
