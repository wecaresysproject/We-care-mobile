import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class QualityOfLifeFilterRow extends StatelessWidget {
  final String? selectedMonth;
  final Function(String) onMonthSelected;
  final VoidCallback onApply;

  const QualityOfLifeFilterRow({
    super.key,
    this.selectedMonth,
    required this.onMonthSelected,
    required this.onApply,
  });

  static const List<String> months = [
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColorsManager.textfieldInsideColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedMonth,
                hint: Text("اختر الشهر", style: AppTextStyles.font16DarkGreyWeight400),
                items: months.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month, style: AppTextStyles.font14BlackMedium),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onMonthSelected(value);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        InkWell(
          onTap: onApply,
          child: Container(
            width: 70.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColorsManager.mainDarkBlue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text(
              "عرض",
              style: AppTextStyles.font14whiteWeight600,
            ),
          ),
        ),
      ],
    );
  }
}
