import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Normal (Uncolored) Text
        Text(
          normalText,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: Color(0xff000000),
          ),
        ),

        horizontalSpacing(8), // Space between normal and highlighted text

        // Highlighted Text with Border and Underline
        Stack(
          children: [
            // Clickable Colored Text
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColorsManager.mainDarkBlue,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  highlightedText,
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
