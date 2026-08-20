import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// بادچ نوع الحجز — أزرق بسماعة للكشف وأخضر للاستشارة،
/// ولما الموعد يحين بيتبدل لـ"حان وقت الكشف/الاستشارة" بأيقونة ساعة.
class BookingTypeBadge extends StatelessWidget {
  const BookingTypeBadge(
      {super.key, required this.type, this.isTimeNow = false});

  final BookingType type;
  final bool isTimeNow;

  @override
  Widget build(BuildContext context) {
    final isExamination = type.isExamination;
    final contentColor = isExamination
        ? OnlineDoctorTheme.headingColor
        : OnlineDoctorTheme.consultationGreen;

    final Widget icon;
    if (isTimeNow) {
      icon = Icon(
        Icons.access_time_rounded,
        size: 13.sp,
        color: isExamination
            ? AppColorsManager.mainDarkBlue
            : OnlineDoctorTheme.consultationGreen,
      );
    } else if (isExamination) {
      icon = Image.asset(
        "assets/images/doctor_examination_tool_icon.png",
        width: 13.w,
        height: 13.w,
        fit: BoxFit.contain,
      );
    } else {
      icon = Icon(
        Icons.question_answer_outlined,
        size: 13.sp,
        color: OnlineDoctorTheme.consultationGreen,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isExamination
            ? OnlineDoctorTheme.iconTint
            : OnlineDoctorTheme.consultationSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          horizontalSpacing(5),
          Flexible(
            child: Text(
              isTimeNow ? type.timeNowBadgeLabel : type.badgeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: contentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
