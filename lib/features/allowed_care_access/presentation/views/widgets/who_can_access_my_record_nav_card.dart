import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class WhoCanAccessMyRecordNavCard extends StatelessWidget {
  final VoidCallback onTap;

  const WhoCanAccessMyRecordNavCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                Icons.admin_panel_settings_outlined,
                color: AppColorsManager.mainDarkBlue,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Texts
            Expanded(
              child: Text(
                'الأشخاص المسموح لهم بالوصول إلى ملفي',
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColorsManager.mainDarkBlue.withOpacity(0.5),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
