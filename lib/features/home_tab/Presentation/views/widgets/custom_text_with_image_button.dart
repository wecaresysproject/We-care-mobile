import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomImageWithTextButtonHomeWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final TextStyle? textStyle;
  final void Function()? onTap;

  const CustomImageWithTextButtonHomeWidget({
    super.key,
    required this.text,
    required this.imagePath,
    this.textStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 144.h,
        width: 252.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 38.h,
        ),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,

          borderRadius: BorderRadius.circular(88.r), // Rounded edges
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8,
              offset: const Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 72.w,
              height: 66.h,
              cacheWidth: 1000,
              cacheHeight: 1000,
            ),
            horizontalSpacing(20),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTextStyles.font22WhiteWeight600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
