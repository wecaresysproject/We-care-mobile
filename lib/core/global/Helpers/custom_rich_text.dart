import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomRichTextWidget extends StatelessWidget {
  final String normalText;
  final String highlightedText;
  final VoidCallback onTap;

  const CustomRichTextWidget({
    super.key,
    required this.normalText,
    required this.highlightedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: normalText, // Normal (Uncolored) Text
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: Color(0xff000000),
            ),
          ),
          TextSpan(
            text: highlightedText, // Clickable & Colored Text
            style: AppTextStyles.font18blackWight500.copyWith(
              color: AppColorsManager.mainDarkBlue,
              decoration: TextDecoration.underline,
              decorationColor: AppColorsManager.mainDarkBlue,
              decorationThickness: 2,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
