import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/generated/l10n.dart';

class AppointmentTypeBadgeWidget extends StatelessWidget {
  const AppointmentTypeBadgeWidget({super.key, required this.type});

  final AppointmentType type;

  @override
  Widget build(BuildContext context) {
    final isExamination = type == AppointmentType.examination;
    final backgroundColor = isExamination
        ? AppColorsManager.examinationBadgeBackground
        : AppColorsManager.consultationBadgeBackground;
    final textColor = isExamination
        ? AppColorsManager.examinationBadgeText
        : AppColorsManager.consultationBadgeText;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExamination
                ? Icons.medical_services_outlined
                : Icons.chat_bubble_outline,
            size: 14.r,
            color: textColor,
          ),
          SizedBox(width: 4.w),
          Text(
            isExamination
                ? S.of(context).examinationBadgeLabel
                : S.of(context).consultationBadgeLabel,
            style: AppTextStyles.font12Weight600.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
