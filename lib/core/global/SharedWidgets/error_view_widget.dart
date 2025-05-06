
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ErrorViewWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorViewWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60.sp,
          ),
          verticalSpacing(16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.font16DarkGreyWeight400,
          ),
          verticalSpacing(24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsManager.mainDarkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              "إعادة المحاولة",
              style: AppTextStyles.font14whiteWeight600,
            ),
          ),
        ],
      ),
    );
  }
}
