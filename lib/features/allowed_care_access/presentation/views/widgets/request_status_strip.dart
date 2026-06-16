import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class RequestStatusStrip extends StatelessWidget {
  final int count;
  const RequestStatusStrip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD).withOpacity(0.5), // Very light blue
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'لديك طلب وصول جديد',
            style: AppTextStyles.font14BlueWeight700.copyWith(
              color: Colors.blue.shade800,
              fontSize: 13.sp,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              count.toString(),
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
