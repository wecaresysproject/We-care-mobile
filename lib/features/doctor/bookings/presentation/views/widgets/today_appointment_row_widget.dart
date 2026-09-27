import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/appointment_time_status_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/appointment_type_badge_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/patient_avatar_widget.dart';
import 'package:we_care/generated/l10n.dart';

class TodayAppointmentRowWidget extends StatelessWidget {
  const TodayAppointmentRowWidget({super.key, required this.appointment});

  final TodayAppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppointmentTimeStatusWidget(
              status: appointment.timeStatus,
              minutes: appointment.statusMinutes,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    appointment.patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14blackWeight600,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time,
                          size: 11.r, color: AppColorsManager.placeHolderColor),
                      SizedBox(width: 3.w),
                      Text(appointment.bookingTimeLabel,
                          style: AppTextStyles.font13GreyWeight400),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            PatientAvatarWidget(
                photoUrl: appointment.patientPhotoUrl, size: 40),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _AllowEntryButton(
              onTap: () =>
                  Navigator.pushNamed(context, Routes.doctorVideoCallView),
            ),
            const Spacer(),
            AppointmentTypeBadgeWidget(type: appointment.type),
          ],
        ),
      ],
    );
  }
}

class _AllowEntryButton extends StatelessWidget {
  const _AllowEntryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColorsManager.mainDarkBlue,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam,
                  size: 14.r, color: AppColorsManager.scaffoldBackGroundColor),
              SizedBox(width: 4.w),
              Text(
                S.of(context).allowEntryAction,
                style: AppTextStyles.font12WhiteWeight700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
