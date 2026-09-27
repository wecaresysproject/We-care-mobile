import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_time_status.dart';
import 'package:we_care/generated/l10n.dart';

class AppointmentTimeStatusWidget extends StatelessWidget {
  const AppointmentTimeStatusWidget({
    super.key,
    required this.status,
    required this.minutes,
  });

  final AppointmentTimeStatus status;
  final int? minutes;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (status) {
      AppointmentTimeStatus.due => (
          Icons.circle,
          AppColorsManager.appointmentDueColor,
          S.of(context).appointmentDueLabel,
        ),
      AppointmentTimeStatus.remaining => (
          Icons.access_time,
          AppColorsManager.appointmentRemainingColor,
          S.of(context).minutesRemainingLabel(minutes ?? 0),
        ),
      AppointmentTimeStatus.late_ => (
          Icons.cancel,
          AppColorsManager.appointmentLateColor,
          S.of(context).minutesLateLabel(minutes ?? 0),
        ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: status == AppointmentTimeStatus.due ? 10.r : 14.r,
            color: color),
        SizedBox(width: 4.w),
        Text(label,
            style: AppTextStyles.font12Weight600.copyWith(color: color)),
      ],
    );
  }
}
