import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalCategorySelectionWidget extends StatelessWidget {
  final List<String> options;
  final Set<String> selectedValues;
  final Function(String value, bool isSelected) onChanged;

  const MedicalCategorySelectionWidget({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor.withOpacity(0.3),
        border:
            Border.all(color: AppColorsManager.mainDarkBlue.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: options.map((option) {
          final isSelected = selectedValues.contains(option);
          return CheckboxListTile(
            title: Text(
              option,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontSize: 14.sp,
              ),
            ),
            value: isSelected,
            onChanged: (bool? value) {
              onChanged(option, value ?? false);
            },
            activeColor: AppColorsManager.mainDarkBlue,
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}
