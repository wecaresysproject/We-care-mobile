import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class RequestDetailsCard extends StatelessWidget {
  final String requestedPermission;
  final String relation;
  final String requestedAt;

  const RequestDetailsCard({
    super.key,
    required this.requestedPermission,
    required this.relation,
    required this.requestedAt,
  });

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: Colors.grey.shade500,
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.font14BlueWeight700.copyWith(
              color: Colors.black87,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل الطلب',
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildRow(
                  'الصلاحية المطلوبة',
                  requestedPermission == 'FULL_ACCESS'
                      ? 'تحكم كامل'
                      : 'قراءة فقط'),
              const Divider(height: 16, color: Color(0xFFF5F5F5)),
              _buildRow('صلة القرابة', relation),
              const Divider(height: 16, color: Color(0xFFF5F5F5)),
              _buildRow('تاريخ الطلب', formatRequestDate(requestedAt)),
            ],
          ),
        ),
      ],
    );
  }
}
