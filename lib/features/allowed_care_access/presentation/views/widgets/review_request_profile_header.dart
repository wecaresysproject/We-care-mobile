import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ReviewRequestProfileHeader extends StatelessWidget {
  const ReviewRequestProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: AppColorsManager.mainDarkBlue,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            'أ',
            style: AppTextStyles.font22MainBlueWeight700.copyWith(
              color: Colors.white,
              fontSize: 40.sp,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // User Name
        Text(
          'أشرف إسماعيل بسيوني',
          style: AppTextStyles.font22MainBlueWeight700.copyWith(
            color: AppColorsManager.mainDarkBlue,
            fontSize: 20.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        // Phone Number
        Text(
          '+20 100 555 7890',
          style: AppTextStyles.font14blackWeight400.copyWith(
            color: Colors.grey.shade500,
            fontSize: 14.sp,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
