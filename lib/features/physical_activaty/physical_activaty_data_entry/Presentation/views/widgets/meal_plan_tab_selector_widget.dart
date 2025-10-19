import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MealPlanTabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const MealPlanTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TabButton(
            title: 'خطة أسبوعية',
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
        ),
        horizontalSpacing(8),
        Expanded(
          child: TabButton(
            title: 'خطة شهرية',
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? AppColorsManager.mainDarkBlue
                  : AppColorsManager.placeHolderColor,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: isSelected
                ? AppColorsManager.mainDarkBlue
                : AppColorsManager.placeHolderColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
