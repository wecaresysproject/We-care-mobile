import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class UsageRateScaleSelector extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const UsageRateScaleSelector({
    super.key,
    required this.options,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColorsManager.textfieldInsideColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: AppColorsManager.textfieldOutsideBorderColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Main gray line
              Container(
                height: 6.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              // Markers and Click Areas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: options.map((option) {
                  final isSelected = selectedOption == option;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onOptionSelected(option),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Marker
                          Container(
                            height: 24.h,
                            width: 6.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColorsManager.mainDarkBlue
                                  : AppColorsManager.mainDarkBlue
                                      .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(3.r),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColorsManager.mainDarkBlue
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          verticalSpacing(12),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((option) {
              final isSelected = selectedOption == option;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onOptionSelected(option),
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontSize: 11.sp,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected
                          ? AppColorsManager.mainDarkBlue
                          : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget verticalSpacing(double height) => SizedBox(height: height.h);
}
