import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomImageWithTextMedicalIllnessModuleWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final bool isTextFirst;

  const CustomImageWithTextMedicalIllnessModuleWidget({
    super.key,
    required this.text,
    required this.imagePath,
    this.textStyle,
    this.onTap,
    this.isTextFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 13.h,
        ),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(75), // 31% opacity
              offset: Offset(3, 4), // X: 3, Y: 4
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: isTextFirst
              ? [_buildText(), horizontalSpacing(20), _buildImage()]
              : [_buildImage(), horizontalSpacing(20), _buildText()],
        ),
      ),
    );
  }

  /// Builds the image widget with preset dimensions and caching.
  Widget _buildImage() {
    return Image.asset(
      imagePath,
      width: 155.w,
      height: 86.h,
      cacheWidth: 1000,
      cacheHeight: 1000,
    );
  }

  /// Builds the text widget with default or custom styling.
  Widget _buildText() {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: textStyle ?? AppTextStyles.font22WhiteWeight600,
        ),
      ),
    );
  }
}
