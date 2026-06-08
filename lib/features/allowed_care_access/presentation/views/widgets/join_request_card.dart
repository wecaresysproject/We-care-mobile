import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class JoinRequestCard extends StatelessWidget {
  final VoidCallback onTap;

  const JoinRequestCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Right Side - Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب انضمام',
                    style: AppTextStyles.font14BlueWeight700.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontSize: 18.sp,
                    ),
                  ),
                  verticalSpacing(8),
                  Text(
                    'أرسل دعوة لشخص لديه حساب. سيُضاف لقائمتك عند قبوله.',
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 13.sp,
                      height: 1.4, // Line spacing
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpacing(16),
            // Mail Icon container
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.mark_email_read_outlined,
                color: AppColorsManager.mainDarkBlue,
                size: 28.sp,
              ),
            ),
            // SizedBox(width: 16.w),
            // // Arrow
            // Icon(
            //   Icons.arrow_back_ios_new,
            //   color: Colors.grey.shade400,
            //   size: 16.sp,
            // ),
          ],
        ),
      ),
    );
  }
}
