import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class RequestActionButtons extends StatelessWidget {
  final VoidCallback onReview;
  final VoidCallback onQuickApprove;

  const RequestActionButtons({
    super.key,
    required this.onReview,
    required this.onQuickApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Primary Action
        Expanded(
          child: OutlinedButton(
            onPressed: onReview,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side:
                  BorderSide(color: AppColorsManager.mainDarkBlue, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'مراجعة الطلب',
              style: AppTextStyles.font14BlueWeight700.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Secondary Quick Action
        Expanded(
          child: ElevatedButton(
            onPressed: onQuickApprove,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: const Color(0xFFE8F5E9), // Soft green
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'قبول سريع',
                  style: AppTextStyles.font14BlueWeight700.copyWith(
                    color: const Color(0xFF2E7D32), // Dark green text
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.check,
                  color: const Color(0xFF2E7D32),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
