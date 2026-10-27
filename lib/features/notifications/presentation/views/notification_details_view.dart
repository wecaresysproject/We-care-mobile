import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/presentation/views/widgets/notification_item.dart';
import 'package:we_care/features/online_doctor/presentation/consultation_call_launcher.dart';

/// تفاصيل رسالة واحدة — نصها، وبيانات الاجتماع (المريض والطبيب والموعد)
/// لرسائل الاستشارات، وزرار "دخول الاستشارة" لما الطبيب يبدأها.
class NotificationDetailsView extends StatelessWidget {
  const NotificationDetailsView({super.key, required this.notification});

  final AppNotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final meeting = notification.meeting;
    final createdAt = notification.createdAt;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        appBar: AppBar(toolbarHeight: 0.h),
        body: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            AppBarWithCenteredTitle(
              title: "تفاصيل الرسالة",
              showActionButtons: false,
            ),
            SizedBox(height: 20.h),
            Text(
              notification.title,
              style: AppTextStyles.font18blackWight500.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColorsManager.textColor,
              ),
            ),
            if (createdAt != null) ...[
              SizedBox(height: 4.h),
              Text(
                timeAgoLabel(createdAt, DateTime.now()),
                style: AppTextStyles.font12blackWeight400.copyWith(
                  color: AppColorsManager.placeHolderColor,
                ),
              ),
            ],
            SizedBox(height: 14.h),
            Text(
              notification.body,
              style: AppTextStyles.font14blackWeight400.copyWith(
                height: 1.7,
                color: AppColorsManager.textColor,
              ),
            ),
            if (meeting != null) ...[
              SizedBox(height: 20.h),
              _MeetingInfoCard(meeting: meeting),
            ],
            if (notification.canJoinConsultation) ...[
              SizedBox(height: 24.h),
              _JoinConsultationButton(
                onPressed: () => ConsultationCallLauncher.open(
                  Navigator.of(context),
                  appointmentId: meeting!.appointmentId,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// كارت بيانات الاجتماع — المريض والطبيب والموعد، وأى سطر فاضى مابيظهرش.
class _MeetingInfoCard extends StatelessWidget {
  const _MeetingInfoCard({required this.meeting});

  final NotificationMeetingData meeting;

  @override
  Widget build(BuildContext context) {
    final rows = [
      (Icons.person_rounded, "المريض", meeting.patientName),
      (Icons.medical_services_rounded, "الطبيب", meeting.doctorName),
      (Icons.event_rounded, "الموعد", meeting.startsAtLabel),
    ].where((row) => row.$3.trim().isNotEmpty).toList();

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          for (final (icon, label, value) in rows)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                children: [
                  Icon(icon, size: 20.sp, color: AppColorsManager.mainDarkBlue),
                  SizedBox(width: 10.w),
                  Text(
                    label,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: AppColorsManager.placeHolderColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.font14BlueWeight700.copyWith(
                        color: AppColorsManager.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _JoinConsultationButton extends StatelessWidget {
  const _JoinConsultationButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsManager.mainDarkBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        icon: Icon(Icons.videocam_rounded, size: 22.sp),
        label: Text(
          "دخول الاستشارة",
          style: AppTextStyles.font14whiteWeight600.copyWith(fontSize: 15.sp),
        ),
      ),
    );
  }
}
