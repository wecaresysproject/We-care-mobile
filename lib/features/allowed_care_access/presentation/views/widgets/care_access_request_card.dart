import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/request_action_buttons.dart';

class CareAccessRequestCard extends StatelessWidget {
  final VoidCallback onReview;
  const CareAccessRequestCard({super.key, required this.onReview});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.medical_information_outlined,
                      color: AppColorsManager.mainDarkBlue,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طلب وصول لملفك الطبي',
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'أشرف إسماعيل يطلب الوصول لملفك بصلاحية تحكم كامل.',
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Metadata
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.grey.shade400,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'منذ دقيقتين',
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Actions
              RequestActionButtons(
                onReview: onReview,
                onQuickApprove: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
