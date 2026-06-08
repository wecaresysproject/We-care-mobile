import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class SelectedUserCard extends StatelessWidget {
  const SelectedUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF), // Light blue tint
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5EEFF)),
      ),
      child: Row(
        children: [
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سارة محمد العمري',
                  style: AppTextStyles.font14BlueWeight700.copyWith(
                    fontSize: 16.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '+20 100 234 5678',
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 13.sp,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
          // // Badge
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFE8F5E9), // Light green background
          //     borderRadius: BorderRadius.circular(20.r),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text(
          //         'موجود',
          //         style: AppTextStyles.font14blackWeight400.copyWith(
          //           color: const Color(0xFF4CAF50), // Green text
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       SizedBox(width: 4.w),
          //       Icon(
          //         Icons.check,
          //         color: const Color(0xFF4CAF50),
          //         size: 14.sp,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
