import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/presentation/views/widgets/invitation_widgets.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/presentation/consultation_call_launcher.dart';

/// تفاصيل دعوة حضور استشارة — الطبيب والموعد، والمريض صاحب الدعوة وصلة
/// القرابة، وزرار دخول غرفة الاستشارة. الإضافة مباشرة من غير قبول أو رفض.
class MeetingInvitationDetailsView extends StatelessWidget {
  const MeetingInvitationDetailsView({super.key, required this.notification});

  /// الدعوة زى ما كانت قبل فتحها — "دعوة جديدة" بتظهر لو كانت غير مقروءة.
  final AppNotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final meeting = notification.meeting!;
    final meetingKind =
        meeting.bookingType.isExamination ? "كشف طبي" : "استشارة طبية";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
              child: Row(
                children: [
                  const CustomBackArrow(),
                  SizedBox(width: 10.w),
                  Text(
                    "تفاصيل الدعوة",
                    style: AppTextStyles.font18blackWight500.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColorsManager.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                children: [
                  if (!notification.isRead) ...[
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _NewInvitationChip(),
                    ),
                    SizedBox(height: 10.h),
                  ],
                  Text(
                    "دعوة لحضور $meetingKind عن بعد",
                    style: AppTextStyles.font20blackWeight600.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColorsManager.textColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "تمت دعوتك من ${meeting.patientName} للانضمام إلى مكالمة "
                    "الفيديو مع الطبيب في الموعد الموضح أدناه.",
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontSize: 13.sp,
                      height: 1.6,
                      color: AppColorsManager.placeHolderColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _DoctorCard(meeting: meeting),
                  SizedBox(height: 14.h),
                  _InviterCard(meeting: meeting),
                ],
              ),
            ),
            _BottomBar(
              onJoinPressed: () => ConsultationCallLauncher.open(
                Navigator.of(context),
                appointmentId: meeting.appointmentId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewInvitationChip extends StatelessWidget {
  const _NewInvitationChip();

  @override
  Widget build(BuildContext context) {
    final primary = AppColorsManager.mainDarkBlue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            "دعوة جديدة",
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// الكارت الأبيض اللى بيلم كل قسم.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE8EDF2)),
      ),
      child: child,
    );
  }
}

/// الطبيب، واليوم والتاريخ، وموعد الاستشارة، ونوعها.
class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.meeting});

  final NotificationMeetingData meeting;

  @override
  Widget build(BuildContext context) {
    final startsAt = meeting.startsAt;
    final primary = AppColorsManager.mainDarkBlue;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InvitationDoctorAvatar(imageUrl: meeting.doctorImage, size: 64.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel("الطبيب"),
                    SizedBox(height: 2.h),
                    Text(
                      meeting.doctorDisplayName,
                      style: AppTextStyles.font18blackWight500.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColorsManager.textColor,
                      ),
                    ),
                    if (meeting.doctorTitleLine.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        meeting.doctorTitleLine,
                        style: AppTextStyles.font14blackWeight400.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ],
                    if (meeting.doctorQualification.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 15.sp,
                            color: AppColorsManager.placeHolderColor,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              meeting.doctorQualification,
                              style:
                                  AppTextStyles.font12blackWeight400.copyWith(
                                fontSize: 11.5.sp,
                                color: AppColorsManager.placeHolderColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (startsAt != null) ...[
            SizedBox(height: 14.h),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _ScheduleBox(
                      icon: Icons.calendar_today_outlined,
                      label: "اليوم والتاريخ",
                      value: arabicWeekdayName(startsAt.weekday),
                      caption: invitationDateLabel(startsAt),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _ScheduleBox(
                      icon: Icons.access_time_rounded,
                      label: meeting.bookingType.isExamination
                          ? "موعد الكشف"
                          : "موعد الاستشارة",
                      value: invitationTimeLabel(startsAt),
                      caption:
                          invitationCountdownLabel(startsAt, DateTime.now()),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 14.h),
          Row(
            children: [
              Icon(Icons.videocam_outlined, size: 18.sp, color: primary),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  meeting.bookingType.isExamination
                      ? "كشف عن بعد بمكالمة فيديو"
                      : "استشارة عن بعد بمكالمة فيديو",
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleBox extends StatelessWidget {
  const _ScheduleBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, size: 18.sp, color: AppColorsManager.mainDarkBlue),
              SizedBox(width: 6.w),
              Expanded(child: _FieldLabel(label)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyles.font18blackWight500.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColorsManager.textColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            caption,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.5.sp,
              color: AppColorsManager.placeHolderColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// المريض صاحب الدعوة ورقمه وصلة القرابة.
class _InviterCard extends StatelessWidget {
  const _InviterCard({required this.meeting});

  final NotificationMeetingData meeting;

  @override
  Widget build(BuildContext context) {
    final primary = AppColorsManager.mainDarkBlue;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              InviterAvatar(imageUrl: meeting.patientImage, size: 56.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel("المريض (صاحب الدعوة)"),
                    SizedBox(height: 2.h),
                    Text(
                      meeting.patientName,
                      style: AppTextStyles.font18blackWight500.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColorsManager.textColor,
                      ),
                    ),
                    if (meeting.patientPhone.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 15.sp,
                            color: primary,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            meeting.patientPhone,
                            textDirection: TextDirection.ltr,
                            style: AppTextStyles.font12blackWeight400.copyWith(
                              fontSize: 12.5.sp,
                              color: AppColorsManager.placeHolderColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (meeting.relation.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: invitationSurface,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel("صلة القرابة"),
                      SizedBox(height: 2.h),
                      Text(
                        meeting.relation,
                        style: AppTextStyles.font16BlackSemiBold.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColorsManager.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.font12blackWeight400.copyWith(
        fontSize: 11.5.sp,
        color: AppColorsManager.placeHolderColor,
      ),
    );
  }
}

/// مكان زرارى القبول والرفض فى التصميم — الإضافة مباشرة، فهنا زرار
/// الدخول بس. شاشة المشارك بتستنى لحد ما الطبيب يبدأ.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onJoinPressed});

  final VoidCallback onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        height: 50.h,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onJoinPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColorsManager.mainDarkBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          icon: Icon(Icons.videocam_rounded, size: 20.sp),
          label: Text(
            "دخول غرفة الاستشارة",
            style: AppTextStyles.font14whiteWeight600.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
