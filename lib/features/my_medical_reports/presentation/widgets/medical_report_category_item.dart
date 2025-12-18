import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalReportCategoryItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onExpandToggle;
  final VoidCallback onCheckboxToggle;

  const MedicalReportCategoryItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isExpanded,
    required this.isSelected,
    required this.onExpandToggle,
    required this.onCheckboxToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkbox (outside tile on the right in RTL)
        GestureDetector(
          onTap: onCheckboxToggle,
          child: Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColorsManager.mainDarkBlue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
              color: isSelected
                  ? AppColorsManager.mainDarkBlue
                  : Colors.transparent,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 18.sp,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        horizontalSpacing(12),
        // The Tile
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onExpandToggle,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Row(
                    children: [
                      // Icon (right side of the tile in RTL)
                      Image.asset(
                        iconPath,
                        width: 28.w,
                        height: 28.h,
                        fit: BoxFit.contain,
                      ),
                      horizontalSpacing(8),
                      // Category title
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.font18blackWight500.copyWith(
                            fontSize: 16.sp,
                            color: AppColorsManager.mainDarkBlue,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      horizontalSpacing(8),
                      // Chevron (left side of the tile in RTL)
                      GestureDetector(
                        onTap: onExpandToggle,
                        child: AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 24.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
