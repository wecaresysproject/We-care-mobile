// Updated Plan Activation Toggle with plan type
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class PlanActivationToggle extends StatelessWidget {
  final bool isActive;
  final Function(bool) onToggle;

  const PlanActivationToggle({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: isActive,
          onChanged: onToggle,
          trackOutlineColor: WidgetStateProperty.all(
            AppColorsManager.placeHolderColor.withAlpha(50),
          ),
          activeColor: AppColorsManager.mainDarkBlue,
          activeTrackColor: Color(0xffDAE9FA),
          inactiveThumbColor: AppColorsManager.placeHolderColor,
          inactiveTrackColor: Colors.grey.withAlpha(100),
        ),
        horizontalSpacing(10),
        Text(
          'تفعيل الخطة',
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    );
  }
}
