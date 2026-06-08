import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AddCarePersonHeader extends StatelessWidget {
  final VoidCallback onClose;

  const AddCarePersonHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'إضافة فرد جديد',
          style: AppTextStyles.font22MainBlueWeight700.copyWith(
            color: AppColorsManager.mainDarkBlue,
            fontSize: 18.sp,
          ),
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'إضافة فرد جديد',
        //       style: AppTextStyles.font22MainBlueWeight700.copyWith(
        //         color: AppColorsManager.mainDarkBlue,
        //         fontSize: 24.sp,
        //       ),
        //     ),
        //     SizedBox(height: 4.h),
        //     Text(
        //       'اختر طريقة الإضافة',
        //       style: AppTextStyles.font14blackWeight400.copyWith(
        //         color: Colors.grey.shade500,
        //       ),
        //     ),
        //   ],
        // ),
        const Spacer(),
        GestureDetector(
          onTap: onClose,
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
    );
  }
}
