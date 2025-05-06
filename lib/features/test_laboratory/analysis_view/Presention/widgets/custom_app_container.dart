
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomAppContainer extends StatelessWidget {
  const CustomAppContainer({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.font12blackWeight400
                .copyWith(fontWeight: FontWeight.w500),
          ),
          horizontalSpacing(8),
          Text(
            value.toString(),
            style: AppTextStyles.font16DarkGreyWeight400
                .copyWith(color: AppColorsManager.mainDarkBlue),
          ),
        ],
      ),
    );
  }
}
