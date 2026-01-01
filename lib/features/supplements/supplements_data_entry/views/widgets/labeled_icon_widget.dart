import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class LabeledIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const LabeledIcon({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColorsManager.mainDarkBlue,
          size: 24,
        ),
        horizontalSpacing(4),
        Text(
          text,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    );
  }
}
