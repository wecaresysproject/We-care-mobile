


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String imagePath;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    required this.imagePath,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 120.h,
            width: 120.w,
          ),
          verticalSpacing(16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16DarkGreyWeight400,
          ),
          verticalSpacing(24),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsManager.mainDarkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              buttonText,
              style: AppTextStyles.font14whiteWeight600,
            ),
          ),
        ],
      ),
    );
  }
}