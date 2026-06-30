import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/data/models/incoming_care_access_requests_response.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/request_action_buttons.dart';

class CareAccessRequestCard extends StatelessWidget {
  final IncomingCareAccessRequestModel request;
  final VoidCallback onReview;
  final VoidCallback? onQuickApprove;

  const CareAccessRequestCard({
    super.key,
    required this.request,
    required this.onReview,
    this.onQuickApprove,
  });

  // String _getPermissionText(String? permission) {
  //   if (permission == 'FULL_ACCESS') {
  //     return 'بصلاحية تحكم كامل';
  //   } else if (permission == 'VIEW_ONLY') {
  //     return 'بصلاحية عرض فقط';
  //   }
  //   return 'بصلاحية غير معروفة';
  // }

  @override
  Widget build(BuildContext context) {
    final requesterName = request.requesterName ?? 'مستخدم مجهول';
    // final permissionText = _getPermissionText(request.requestedPermission);
    final description = '$requesterName يطلب الوصول لملفك الطبي.';
    final timeAgo = formatTimeAgo(request.timeAgo ?? request.requestedAt);

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
                          description,
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
                    timeAgo,
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
                onQuickApprove: () {
                  if (onQuickApprove != null) {
                    onQuickApprove!();
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  String formatTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'غير معروف';
    }

    try {
      final date = DateTime.parse(dateString).toLocal();
      final difference = DateTime.now().difference(date);

      if (difference.inSeconds < 60) {
        return 'منذ لحظات';
      }

      if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;

        if (minutes == 1) return 'منذ دقيقة';
        if (minutes == 2) return 'منذ دقيقتين';

        return 'منذ $minutes دقائق';
      }

      if (difference.inHours < 24) {
        final hours = difference.inHours;

        if (hours == 1) return 'منذ ساعة';
        if (hours == 2) return 'منذ ساعتين';

        return 'منذ $hours ساعات';
      }

      if (difference.inDays < 30) {
        final days = difference.inDays;

        if (days == 1) return 'منذ يوم';
        if (days == 2) return 'منذ يومين';

        return 'منذ $days أيام';
      }

      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return 'غير معروف';
    }
  }
}
