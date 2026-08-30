import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_summary_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت الطبيب فى شاشة "البحث عن طبيب" — بيانات الطبيب فى البداية،
/// وحالة التواجد وأقرب موعد فى النهاية.
class DoctorCardItem extends StatelessWidget {
  const DoctorCardItem({
    super.key,
    required this.doctor,
    this.onTap,
  });

  final DoctorSummaryModel doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: OnlineDoctorTheme.doctorCardSurface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColorsManager.mainDarkBlue.withAlpha(15),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _DoctorSummary(doctor: doctor)),
              horizontalSpacing(8),
              _DoctorAvailability(doctor: doctor),
              horizontalSpacing(4),
              Center(
                child: Image.asset(
                  "assets/images/side_arrow_filled.png",
                  width: 11.w,
                  height: 15.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary({required this.doctor});

  final DoctorSummaryModel doctor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DoctorPhoto(imageUrl: doctor.imageUrl),
            horizontalSpacing(6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doctor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font16BlackSemiBold.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: OnlineDoctorTheme.headingColor,
                    ),
                  ),
                  verticalSpacing(4),
                  Text(
                    doctor.specialty,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: OnlineDoctorTheme.headingColor,
                    ),
                  ),
                  verticalSpacing(6),
                  Text(
                    doctor.workplace,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      fontSize: 8.sp,
                      height: 1.4,
                      color: const Color.fromARGB(255, 45, 45, 45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpacing(10),
        _DoctorStatsRow(doctor: doctor),
      ],
    );
  }
}

class _DoctorPhoto extends StatelessWidget {
  const _DoctorPhoto({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 64.w,
        height: 72.h,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: SizedBox(
              width: 18.w,
              height: 18.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColorsManager.mainDarkBlue.withAlpha(120),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.white,
            padding: EdgeInsets.all(6.w),
            child: Image.asset(
              "assets/images/doctor_or_specialist.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

/// صف التقييم والإعجابات والتعليقات أسفل بيانات الطبيب.
class _DoctorStatsRow extends StatelessWidget {
  const _DoctorStatsRow({required this.doctor});

  final DoctorSummaryModel doctor;

  @override
  Widget build(BuildContext context) {
    final valueStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: OnlineDoctorTheme.mutedText,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 15.sp,
            color: OnlineDoctorTheme.ratingAmber,
          ),
          horizontalSpacing(3),
          Text(
            doctor.rating.toStringAsFixed(1),
            style: valueStyle.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: OnlineDoctorTheme.headingColor,
            ),
          ),
          const _StatsDivider(),
          Icon(
            Icons.thumb_up_rounded,
            size: 12.sp,
            color: OnlineDoctorTheme.likesBlue,
          ),
          horizontalSpacing(4),
          Text("${doctor.likesCount} إعجاب", style: valueStyle),
          const _StatsDivider(),
          Icon(
            Icons.mode_comment_outlined,
            size: 12.sp,
            color: OnlineDoctorTheme.likesBlue,
          ),
          horizontalSpacing(4),
          Text("${doctor.commentsCount} تعليق", style: valueStyle),
        ],
      ),
    );
  }
}

class _StatsDivider extends StatelessWidget {
  const _StatsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Container(
        width: 1,
        height: 12.h,
        color: OnlineDoctorTheme.statsDivider,
      ),
    );
  }
}

/// العمود اللى فى نهاية الكارت: حالة التواجد، قبول الحجوزات، وأقرب موعد.
class _DoctorAvailability extends StatelessWidget {
  const _DoctorAvailability({required this.doctor});

  final DoctorSummaryModel doctor;

  /// "الخميس 27 أغسطس - 04:00 مساءً" — أو رسالة لو مفيش موعد متاح.
  String get _nearestAppointmentLabel {
    final appointment = doctor.nearestAvailableAppointment;
    if (appointment == null) return "لا يوجد موعد متاح حاليًا";
    return "${appointment.dateLabel} - ${appointment.timeLabel}";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusBadge(isOnline: doctor.isOnline),
          verticalSpacing(2),
          _AvailabilityRow(
            icon: doctor.acceptsBookings
                ? Icons.check_circle_rounded
                : Icons.block_rounded,
            iconColor: doctor.acceptsBookings
                ? OnlineDoctorTheme.onlineGreen
                : OnlineDoctorTheme.offlineRed,
            label: doctor.acceptsBookings
                ? "يقبل حجوزات حالياً"
                : "لا يقبل حجوزات حالياً",
          ),
          verticalSpacing(2),
          const _AvailabilityRow(
            icon: Icons.calendar_month_rounded,
            iconColor: AppColorsManager.mainDarkBlue,
            label: "أقرب موعد متاح",
          ),
          verticalSpacing(2),
          _AvailabilityRow(
            icon: Icons.access_time_rounded,
            iconColor: AppColorsManager.mainDarkBlue,
            label: _nearestAppointmentLabel,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOnline
            ? OnlineDoctorTheme.onlineGreen
            : OnlineDoctorTheme.offlineRed,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              isOnline ? "اون لاين" : "غير متاح الآن",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          horizontalSpacing(4),
          Icon(
            isOnline ? Icons.person_rounded : Icons.person_off_rounded,
            size: 12.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  const _AvailabilityRow({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              label,
              maxLines: 1,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
          ),
        ),
        horizontalSpacing(4),
        Icon(icon, size: 12.sp, color: iconColor),
      ],
    );
  }
}
