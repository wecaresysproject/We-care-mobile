import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';

/// كارت رسالة فى صفحة الرسائل — غير المقروءة بخلفية زرقا فاتحة.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotificationModel notification;
  final VoidCallback onTap;

  IconData get _icon => switch (notification.type) {
        AppNotificationType.meetingParticipantAdded => Icons.group_add_rounded,
        AppNotificationType.consultationStarted => Icons.videocam_rounded,
        AppNotificationType.unknown => Icons.notifications_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final createdAt = notification.createdAt;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : AppColorsManager.babyBlueColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColorsManager.placeHolderColor.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColorsManager.mainDarkBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                color: AppColorsManager.mainDarkBlue,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.font14BlueWeight700.copyWith(
                            color: AppColorsManager.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (createdAt != null)
                        Text(
                          timeAgoLabel(createdAt, DateTime.now()),
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            color: AppColorsManager.placeHolderColor,
                            fontSize: 10.sp,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      color: AppColorsManager.textColor.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "منذ 5 دقائق" — وبعد أسبوع التاريخ نفسه.
String timeAgoLabel(DateTime time, DateTime now) {
  final difference = now.difference(time);
  if (difference.inMinutes < 1) return "الآن";
  if (difference.inHours < 1) return "منذ ${difference.inMinutes} دقيقة";
  if (difference.inDays < 1) return "منذ ${difference.inHours} ساعة";
  if (difference.inDays < 7) return "منذ ${difference.inDays} يوم";
  return "${time.day}/${time.month}/${time.year}";
}
