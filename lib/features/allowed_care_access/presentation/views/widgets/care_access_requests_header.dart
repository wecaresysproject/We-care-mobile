import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CareAccessRequestsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const CareAccessRequestsHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: AppColorsManager.mainDarkBlue,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'طلبات الوصول لحسابي',
                          style: AppTextStyles.font22MainBlueWeight700.copyWith(
                            color: AppColorsManager.mainDarkBlue,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'الأشخاص الذين يطلبون الوصول لملفك الطبي',
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColorsManager.mainDarkBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
