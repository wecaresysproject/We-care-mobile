import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class GenderQuestionWidget extends StatefulWidget {
  final Function(bool?)? onAnswerChanged;
  final bool? initialValue;

  const GenderQuestionWidget({
    super.key,
    this.onAnswerChanged,
    this.initialValue,
  });

  @override
  State<GenderQuestionWidget> createState() => _GenderQuestionWidgetState();
}

class _GenderQuestionWidgetState extends State<GenderQuestionWidget> {
  String? selectedAnswer; // "ذكر" or "أنثى"

  @override
  void initState() {
    super.initState();
    // Convert bool to String for radio button compatibility
    if (widget.initialValue == true) {
      selectedAnswer = 'ذكر';
    } else if (widget.initialValue == false) {
      selectedAnswer = 'أنثى';
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
    if (value == 'ذكر') {
      boolValue = true;
    } else if (value == 'أنثى') {
      boolValue = false;
    } else {
      boolValue = null;
    }

    widget.onAnswerChanged?.call(boolValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Color(0xFFECF5FF), // Light blue-white
            Color(0xFFFBFDFF), // Very light blue-white
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRadioOption(label: "ذكر", value: "ذكر"),
          _buildRadioOption(label: "أنثى", value: "أنثى"),
        ],
      ),
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
            onChanged: _handleAnswerChange,
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
