import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت مختصر أعلى شاشتى "تعديل التقييم" و"تعديل التعليق" —
/// اسم الطبيب وتخصصه ونوع الموعد وتاريخه، عشان المستخدم يعرف بيقيّم أنهى موعد.
class BookingReviewHeaderCard extends StatelessWidget {
  const BookingReviewHeaderCard({super.key, required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.cardSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.doctor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: OnlineDoctorTheme.headingColor,
            ),
          ),
          verticalSpacing(2),
          Text(
            booking.doctor.specialization,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: OnlineDoctorTheme.accentBlue,
            ),
          ),
          verticalSpacing(10),
          Container(height: 1, color: OnlineDoctorTheme.cardBorder),
          verticalSpacing(10),
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 15.sp,
                color: AppColorsManager.mainDarkBlue,
              ),
              horizontalSpacing(5),
              Flexible(
                child: Text(
                  "${booking.type.badgeLabel} - ${booking.dateLabel}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: OnlineDoctorTheme.headingColor,
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
