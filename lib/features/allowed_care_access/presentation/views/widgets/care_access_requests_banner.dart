import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CareAccessRequestsBanner extends StatelessWidget {
  final VoidCallback onTap;
  final int pendingRequests;

  const CareAccessRequestsBanner({
    super.key,
    required this.onTap,
    required this.pendingRequests,
  });

  @override
  Widget build(BuildContext context) {
    // if (pendingRequests == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color:
              AppColorsManager.mainDarkBlue.withOpacity(0.04), // Soft blue tint
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.person_add_alt_1_outlined,
                color: AppColorsManager.mainDarkBlue,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Texts
            Text(
              'عرض طلبات الوصول الخاص بي',
              style: AppTextStyles.font14BlueWeight700.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontSize: 14.sp,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F2), // Light red/orange
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$pendingRequests',
                style: AppTextStyles.font14blackWeight400.copyWith(
                  color: const Color(0xFFE53935), // Red
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
