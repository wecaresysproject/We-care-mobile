import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class JoinCareRequestHeader extends StatelessWidget {
  final VoidCallback onBack;

  const JoinCareRequestHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب انضمام',
                  style: AppTextStyles.font22MainBlueWeight700.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'ادخل رقم الهاتف الخاص بالمريض',
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 44.w,
                height: 44.w,
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
