import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// كارت بيانات الطبيب أعلى شاشة "ملف الطبيب" — الصورة فى النهاية،
/// والاسم والتخصص وأرقام التقييم فى البداية.
class DoctorProfileHeaderCard extends StatelessWidget {
  const DoctorProfileHeaderCard({
    super.key,
    required this.doctor,
    required this.isFavorite,
    this.onFavoriteToggled,
  });

  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.mainDarkBlue.withAlpha(13),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _NameRow(
                  doctor: doctor,
                  isFavorite: isFavorite,
                  onFavoriteToggled: onFavoriteToggled,
                ),
                verticalSpacing(4),
                Text(
                  doctor.specialization,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: OnlineDoctorTheme.accentBlue,
                  ),
                ),
                verticalSpacing(8),
                _IconLine(
                  icon: Icons.school_outlined,
                  text: "${doctor.academicTitle}  —  ${doctor.hospital}",
                ),
                verticalSpacing(4),
                _IconLine(
                  icon: Icons.location_on_outlined,
                  text: doctor.location,
                ),
                verticalSpacing(10),
                _StatsRow(doctor: doctor),
              ],
            ),
          ),
          horizontalSpacing(10),
          _DoctorPhoto(doctor: doctor),
        ],
      ),
    );
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({
    required this.doctor,
    required this.isFavorite,
    this.onFavoriteToggled,
  });

  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onFavoriteToggled,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: OnlineDoctorTheme.sectionBorder),
            ),
            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 15.sp,
              color: isFavorite
                  ? OnlineDoctorTheme.offlineRed
                  : OnlineDoctorTheme.accentBlue,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  doctor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
              ),
              if (doctor.isVerified) ...[
                horizontalSpacing(4),
                Icon(
                  Icons.verified_rounded,
                  size: 15.sp,
                  color: OnlineDoctorTheme.accentBlue,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 12.sp, color: OnlineDoctorTheme.mutedText),
        horizontalSpacing(4),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 9.sp,
              height: 1.35,
              color: const Color.fromARGB(255, 45, 45, 45),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: Icons.star_rounded,
            iconColor: OnlineDoctorTheme.ratingAmber,
            value: doctor.rating.toStringAsFixed(1),
            label: "تقييم (من 5)",
          ),
        ),
        horizontalSpacing(6),
        Expanded(
          child: _StatBox(
            icon: Icons.thumb_up_rounded,
            iconColor: OnlineDoctorTheme.likesBlue,
            value: "${doctor.likesCount}",
            label: "إعجاب",
          ),
        ),
        horizontalSpacing(6),
        Expanded(
          child: _StatBox(
            icon: Icons.chat_bubble_rounded,
            iconColor: OnlineDoctorTheme.likesBlue,
            value: "${doctor.commentsCount}",
            label: "تعليق",
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
                horizontalSpacing(4),
                Icon(icon, size: 14.sp, color: iconColor),
              ],
            ),
          ),
          verticalSpacing(2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 8.5.sp,
                color: OnlineDoctorTheme.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorPhoto extends StatelessWidget {
  const _DoctorPhoto({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112.w,
      height: 150.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: CachedNetworkImage(
                imageUrl: doctor.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: OnlineDoctorTheme.sectionSurface,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColorsManager.mainDarkBlue.withAlpha(120),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: OnlineDoctorTheme.sectionSurface,
                  padding: EdgeInsets.all(16.w),
                  child: Image.asset(
                    "assets/images/doctor_or_specialist.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 8.h,
            end: 6.w,
            child: _AvailabilityPill(isOnline: doctor.isOnline),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityPill extends StatelessWidget {
  const _AvailabilityPill({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final color =
        isOnline ? OnlineDoctorTheme.onlineGreen : OnlineDoctorTheme.offlineRed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isOnline ? "متاح الآن" : "غير متاح الآن",
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          horizontalSpacing(4),
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
