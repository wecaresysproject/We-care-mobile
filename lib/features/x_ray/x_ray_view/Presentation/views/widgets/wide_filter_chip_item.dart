import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class WideFilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const WideFilterChipItem({
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
        constraints: const BoxConstraints(minWidth: 160),
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 12),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Image.asset('assets/images/check_icon.png', width: 10, height: 10),
            if (isSelected) horizontalSpacing(3),
            Text(
              label,
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: AppTextStyles.font12blackWeight400.copyWith(
                color: isSelected
                    ? AppColorsManager.mainDarkBlue
                    : Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}


