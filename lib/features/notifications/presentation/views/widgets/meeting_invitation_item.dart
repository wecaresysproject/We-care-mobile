import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/presentation/views/widgets/invitation_widgets.dart';
import 'package:we_care/features/notifications/presentation/views/widgets/notification_item.dart';

/// كارت دعوة لحضور استشارة — صاحب الدعوة، كارت الطبيب والموعد، وزرار
/// "عرض تفاصيل الدعوة". النقطة جنب العنوان معناها إن الدعوة لسه متقريتش.
class MeetingInvitationItem extends StatelessWidget {
  const MeetingInvitationItem({
    super.key,
    required this.notification,
    required this.meeting,
    required this.onTap,
  });

  final AppNotificationModel notification;
  final NotificationMeetingData meeting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final createdAt = notification.createdAt;
    final startsAt = meeting.startsAt;
    final primary = AppColorsManager.mainDarkBlue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: primary.withValues(alpha: notification.isRead ? 0.15 : 0.45),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InviterAvatar(imageUrl: meeting.patientImage, size: 50.w),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${meeting.patientName} يدعوك لحضور "
                        "${invitationMeetingName(meeting.bookingType)}",
                        style: AppTextStyles.font16BlackSemiBold.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                          color: AppColorsManager.textColor,
                        ),
                      ),
                      if (createdAt != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          timeAgoLabel(createdAt, DateTime.now()),
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            fontSize: 11.5.sp,
                            color: AppColorsManager.placeHolderColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.w, top: 8.h),
                    child: Container(
                      width: 9.w,
                      height: 9.w,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: invitationSurface,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InvitationDoctorAvatar(
                        imageUrl: meeting.doctorImage,
                        size: 40.w,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meeting.doctorDisplayName,
                              style: AppTextStyles.font14BlueWeight700
                                  .copyWith(color: AppColorsManager.textColor),
                            ),
                            if (meeting.doctorTitleLine.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                meeting.doctorTitleLine,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppTextStyles.font12blackWeight400.copyWith(
                                  fontSize: 11.5.sp,
                                  color: AppColorsManager.placeHolderColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (startsAt != null) ...[
                    SizedBox(height: 12.h),
                    // بيلف لسطرين على الشاشات الضيقة بدل ما يطلع برا الكارت.
                    Wrap(
                      spacing: 18.w,
                      runSpacing: 6.h,
                      children: [
                        _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: invitationDayLabel(startsAt),
                        ),
                        _InfoChip(
                          icon: Icons.access_time_rounded,
                          label: invitationTimeLabel(startsAt),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              height: 46.h,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  "عرض تفاصيل الدعوة",
                  style: AppTextStyles.font14whiteWeight600.copyWith(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: AppColorsManager.mainDarkBlue),
        SizedBox(width: 5.w),
        Text(
          label,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColorsManager.textColor,
          ),
        ),
      ],
    );
  }
}
