import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class PermissionExplanationCard extends StatelessWidget {
  const PermissionExplanationCard({super.key});

  Widget _buildItem(String text, bool allowed) {
    return Row(
      children: [
        Icon(
          allowed ? Icons.check_circle : Icons.cancel,
          color: allowed ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: Colors.grey.shade800,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue tint
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: AppColorsManager.mainDarkBlue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'ما الذي سيستطيع فعله؟',
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildItem('الاطلاع على ملفك الطبي كاملاً', true),
          SizedBox(height: 8.h),
          _buildItem('إضافة وتعديل البيانات الطبية', true),
          SizedBox(height: 8.h),
          _buildItem('لا يستطيع حذف ملفك', false),
          SizedBox(height: 8.h),
          _buildItem('لا يستطيع منح صلاحيات لغيره', false),
        ],
      ),
    );
  }
}
