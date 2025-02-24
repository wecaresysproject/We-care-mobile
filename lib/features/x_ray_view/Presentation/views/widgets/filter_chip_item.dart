import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints:
            const BoxConstraints(minWidth: 50), // Prevents extreme shrinking
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColorsManager.mainDarkBlue
                : const Color(0xFF555555),
            width: isSelected ? 1.2 : 0.5,
          ),
          color: Colors.transparent,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Prevents unnecessary expansion
            children: [
              if (isSelected)
                Image.asset('assets/images/check_icon.png',
                    width: 10, height: 10),
              if (isSelected) horizontalSpacing(2), // Avoid spacing issues
              Flexible(
                child: Text(
                  label,
                  // overflow:
                  //     TextOverflow.ellipsis, // Ensures text doesn't overflow
                  maxLines: 1, // Prevents multiline overflow
                  softWrap: false, // Keeps text in one line
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    color: isSelected
                        ? AppColorsManager.mainDarkBlue
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
