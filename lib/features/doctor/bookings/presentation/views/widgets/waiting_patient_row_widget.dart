import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/waiting_patient_model.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/appointment_type_badge_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/patient_avatar_widget.dart';
import 'package:we_care/generated/l10n.dart';

class WaitingPatientRowWidget extends StatelessWidget {
  const WaitingPatientRowWidget({
    super.key,
    required this.patient,
    required this.onAccept,
    required this.onReject,
  });

  final WaitingPatientModel patient;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time,
                    size: 11.r, color: AppColorsManager.placeHolderColor),
                SizedBox(width: 3.w),
                Text(
                  S.of(context).minutesAgoLabel(patient.waitingMinutes),
                  style: AppTextStyles.font13GreyWeight400,
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    patient.patientName,
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
                      Text(patient.joinRequestTimeLabel,
                          style: AppTextStyles.font13GreyWeight400),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            PatientAvatarWidget(photoUrl: patient.patientPhotoUrl, size: 40),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _ActionButton(
              label: S.of(context).rejectAction,
              icon: Icons.close,
              backgroundColor: AppColorsManager.rejectButtonBackground,
              borderColor: AppColorsManager.rejectButtonBorder,
              foregroundColor: AppColorsManager.rejectButtonText,
              onTap: onReject,
            ),
            SizedBox(width: 8.w),
            _ActionButton(
              label: S.of(context).acceptAction,
              icon: Icons.check,
              backgroundColor: AppColorsManager.acceptButtonBackground,
              borderColor: AppColorsManager.acceptButtonBorder,
              foregroundColor: AppColorsManager.acceptButtonText,
              onTap: onAccept,
            ),
            const Spacer(),
            AppointmentTypeBadgeWidget(type: patient.type),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColorsManager.scaffoldBackGroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16.r,
              height: 16.r,
              decoration:
                  BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
              child: Icon(icon, size: 11.r, color: foregroundColor),
            ),
            SizedBox(width: 4.w),
            Text(label,
                style: AppTextStyles.font12Weight600
                    .copyWith(color: foregroundColor)),
          ],
        ),
      ),
    );
  }
}
