import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_access_request_details_response.dart';

class PermissionExplanationCard extends StatelessWidget {
  final List<PermissionCapabilityModel> capabilities;

  const PermissionExplanationCard({super.key, required this.capabilities});

  Widget _buildItem(String text, bool allowed) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (capabilities.isEmpty) return const SizedBox.shrink();

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
          ...capabilities.map((cap) => _buildItem(cap.title, cap.allowed)),
        ],
      ),
    );
  }
}
